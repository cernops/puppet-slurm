```
 _____ _     _   __________  ___
/  ___| |   | | | | ___ \  \/  |
\ `--.| |   | | | | |_/ / .  . |
 `--. \ |   | | | |    /| |\/| |
/\__/ / |___| |_| | |\ \| |  | |
\____/\_____/\___/\_| \_\_|  |_/

```
# Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with slurm](#setup)
    * [What slurm affects](#what-slurm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with slurm](#beginning-with-slurm)
3. [Usage](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors](#contributors)

# Description

This module installs the SLURM scheduler for running parallel programs on an HPC cluster.

It sets up, configures and installs all required binaries and configuration files according to the parameters shown [below](#beginning-with-slurm). It relies on hiera data provided by the hostgroup it is included in.

# Setup

## What slurm affects

### Packages installed by the module

To avoid version conflicts, all the following packages will be installed/replaced by the module :

#### On all type of nodes
```
 - 'slurm',
 - 'slurm-devel',
 - 'slurm-munge',
 - 'munge',
 - 'munge-libs',
 - 'munge-devel',
```

#### On the database nodes
```
 - 'slurm-plugins',
 - 'slurm-slurmdbd',
 - 'slurm-sql',
```

#### On the headnodes
```
 - 'slurm-auth-none',
 - 'slurm-perlapi',
 - 'slurm-plugins',
 - 'slurm-torque',
```

#### On the worker nodes
```
 - 'slurm-auth-none',
 - 'slurm-perlapi',
 - 'slurm-plugins',
 - 'slurm-torque',
```

### Dependencies

#### Authentication
The default (and only supported) authentication mechanism for SLURM is [MUNGE](https://dun.github.io/munge/). It is set in the configuration file `slurm.conf` as follows:
```
AuthType=auth/munge
```
Other alternatives for this value is `auth/none` which requires the `auth-none` plugin to be built as part of SLURM. It is recommended to use MUNGE rather than unauthenticated communication.

<!---
#### Checkpointing
This feature is currently not available since the main project, i.e. BLCR, has been discontinued since 2013. We are investigating alternatives like DMTCP, SCR and OpenMPI's build it checkpointing mechanism.
--->

#### Database configuration
The database for SLURM is used solely for accounting purposes. The module supports a setup with a database node either separate from or combined with a headnode. The database configuration is done in the [dbnode](manifests/dbnode) manifests.

The main configuration values (as defined in [slurm.conf](#slurm.conf.erb) and [slurmdbd.conf](#slurmdbd.conf.erb) for the database are the following:
```ruby
# class slurm::config
String $accounting_storage_host     = 'accountingdb.example.org',                 # DB node hostname
String $accounting_storage_loc      = 'slurm_acct_db',                            # DB name (inside the MySQL DB)
String $accounting_storage_pass     = '/var/run/munge/munge.socket.2',            # DB authentication (password or munge)
Integer $accounting_storage_port    = 6819,                                       # DB node port
String $accounting_storage_type     = 'accounting_storage/none',                  # Type of storage (none, filetext, mysql, slurmdbd)
String $accounting_storage_user     = 'slurm',                                    #
String $cluster_name                = 'mycluster',                                #
String $job_acct_gather_frequency   = 'task=30,energy=0,network=0,filesystem=0',  # Accounting sampling interval
String $job_acct_gather_type        = 'jobacct_gather/none',                      # Accounting mechanism (none or linux)
String $acct_gather_energy_type     = 'acct_gather_energy/none',                  # Energy accounting plugin (none, ipmi, rapl)
String $acct_gather_infiniband_type = 'acct_gather_infiniband/none',              # Infiniband accounting plugin (none, ofed)
String $acct_gather_filesystem_type = 'acct_gather_filesystem/none',              # Filesystem accounting plugin (none, lustre)
String $acct_gather_profile_type    = 'acct_gather_profile/none',                 # Job profiling plugin (none, hdfs5)

# class slurm::dbnode::config
String $dbd_host      = 'localhost',                                              # DB node hostname (either headnode or dbnode hostname. Preferably `localhost`.)
Integer $dbd_port     = 6819,                                                     # DB node port
String $slurm_user    = 'slurm',                                                  #
String $storage_host  = 'db_instance.example.org',                                # Hostname of the node where MySQL instance is running
Integer $storage_port = 1234,                                                     # MySQL instance port number
String $storage_user  = 'user',                                                   #
String $storage_loc   = 'accountingdb',                                           # DB name (inside the MySQL DB)
```

If the database is running on a headnode, and locally, the hostnames can be set as `localhost`.
Further information can be found in the [official documentation](https://slurm.schedmd.com/accounting.html).


## Setup requirements

If you use this module at CERN, it needs to be enabled in the pluginsync filter :
```
# my_hostgroup.yaml

...

# enabling the slurm module
pluginsync_filter:
 - slurm

...
```

## Beginning with slurm

To use the module, first include it in your hostgroup manifest :
```
# my_hostgroup.pp

...

# including slurm to be able to do some awesome scheduling on HPC machines
include ::slurm

# put my secret mungekey on all the machine for the MUNGE security plugin
file{ '/etc/munge/munge.key':
  ensure  => file,
  content => 'YourIncrediblyStrongSymetricKey',
  owner   => 'munge',
  group   => 'munge',
  mode    => '0400',
}

...
```
and then make sure you have all the necessary configuration options in data; without any data, the module will *not* work, puppet will trigger a warning and nothing will be installed and/or configured.

The following minimal configuration is required for the module to work
```
# my_hostgroup.yaml

slurm::config::control_machine: slurm-master.yourdomain.com

slurm::config::workernodes:
  -
    NodeName: slave[001-010]
    CPUs: 16
    RealMemory: 64000
    State: UNKNOWN

slurm::config::partitions:
  -
    PartitionName: Arena
    Nodes: ALL
    Default: YES
    State: UP
...
```
i.e. you need a master controller, at least one workernode and a partition containing the nodes.

# Usage

Please refer to the official [SLURM documentation](https://slurm.schedmd.com/).

# References

## slurm
```ruby
class slurm (
  Enum['worker','head','db','db-head','none'] $node_type = 'none',
)
```
The main class is responsible to call the relevant node type classes according to node_type parameter or to warn the user that he did not specify any node type.


## slurm::setup
```ruby
class slurm::setup (
  Integer[0,default] $slurm_gid = 950,
  Integer[0,default] $slurm_uid = 950,
  String[1,default] $slurm_home_loc = '/usr/local/slurm',
  String[1,default] $slurm_log_file = '/var/log/slurm',
  String[1,default] $slurm_plugstack_loc = '/etc/slurm/plugstack.conf.d',
  Integer[0,default] $munge_gid = 951,
  Integer[0,default] $munge_uid = 951,
  String[1,default] $munge_loc = '/etc/munge',
  String[1,default] $munge_log_file = '/var/log/munge',
  String[1,default] $munge_home_loc = '/var/lib/munge',
  String[1,default] $munge_run_loc = '/run/munge',
) inherits slurm::config
```
The setup class, common to all types of nodes, is responsible to set up all the folders and keys needed by SLURM to work correctly. For more details about each parameter, please refer to the header of [setup.pp](manifest/setup.pp).


## slurm::config
```ruby
class slurm::config (
  String[1,default] $control_machine = 'headnode1.example.org',
  String[0,default] $control_addr = $control_machine,
  String[0,default] $backup_controller = '',
  String[0,default] $backup_addr = $backup_controller,
  Integer[0,1] $allow_spec_resources_usage = 0,
  Enum['checkpoint/blcr','checkpoint/none','checkpoint/ompi','checkpoint/poe'] $checkpoint_type= 'checkpoint/none',
  String[0,default] $chos_loc = '',
  Enum['core_spec/cray','core_spec/none'] $core_spec_plugin = 'core_spec/none',
  Enum['Conservative','OnDemand','Performance','PowerSave'] $cpu_freq_def = 'Performance',
  Array[Enum['Conservative','OnDemand','Performance','PowerSave','UserSpace']] $cpu_freq_governors = ['OnDemand','Performance'],
  Enum['NO','YES'] $disable_root_jobs = 'NO',
  Enum['NO','YES'] $enforce_part_limits = 'NO',
  Enum['ext_sensors/none','ext_sensors/rrd'] $ext_sensors_type = 'ext_sensors/none',
  Integer[0,default] $ext_sensors_freq = 0,
  Integer[1,default] $first_job_id = 1,
  Integer[1,default] $max_job_id = 999999,
  Array[String[1,default]] $gres_types = [],
  Integer[0,1] $group_update_force = 0,
  String[1,default] $job_checkpoint_dir = '/var/slurm/checkpoint',
  Enum['job_container/cncu','job_container/none'] $job_container_type = 'job_container/none',
  Integer[0,1] $job_file_append = 0,
  Integer[0,1] $job_requeue = 0,
  Array[String[1,default]] $job_submit_plugins = [],
  Integer[0,1] $kill_on_bad_exit = 0,
  Enum['launch/aprun','launch/poe','launch/runjob','launch/slurm'] $launch_type = 'launch/slurm',
  Array[Enum['mem_sort','slurmstepd_memlock','slurmstepd_memlock_all','test_exec']] $launch_parameters = [],
  Array[String[1,default]] $licenses = [],
  Enum['node_features/knl_cray','node_features/knl_generic',''] $node_features_plugins = '',
  String[1,default] $mail_prog = '/bin/mail',
  String[0,default] $mail_domain = '',
  Integer[1,default] $max_job_count = 10000,
  Integer[1,default] $max_step_count = 40000,
  Enum['no','yes'] $mem_limit_enforce = 'yes',
  Hash[Enum['WindowMsgs','WindowTime'],Integer[1,default]] $msg_aggregation_params = {'WindowMsgs' => 1, 'WindowTime' => 100},
  String[1,default] $plugin_dir = '/usr/local/lib/slurm',
  String[0,default] $plug_stack_config = '',
  Enum['power/cray','power/none'] $power_plugin = 'power/none',
  Array[String[1,default]] $power_parameters = [],
  Enum['preempt/none','preempt/partition_prio','preempt/qos'] $preempt_type = 'preempt/none',
  Array[Enum['OFF','CANCEL','CHECKPOINT','GANG','REQUEUE','SUSPEND']] $preempt_mode = ['OFF'],
  Array[Enum['accounts','cloud','jobs','nodes','partitions','reservations','usage','users']] $private_data = [],
  Enum['proctrack/cgroup','proctrack/cray','proctrack/linuxproc','proctrack/lua','proctrack/sgi_job','proctrack/pgid',''] $proctrack_type = '',
  Integer[0,2] $propagate_prio_process = 0,
  Array[Enum['ALL','NONE','AS','CORE','CPU','DATA','FSIZE','MEMLOCK','NOFILE','NPROC','RSS','STACK']] $propagate_resource_limits = [],
  Array[Enum['ALL','NONE','AS','CORE','CPU','DATA','FSIZE','MEMLOCK','NOFILE','NPROC','RSS','STACK']] $propagate_resource_limits_except = [],
  String[0,default] $reboot_program = '',
  Enum['KeepPartInfo','KeepPartState',''] $reconfig_flags = '',
  String[0,default] $resv_epilog = '',
  String[0,default] $resv_prolog = '',
  Integer[0,2] $return_to_service = 0,
  String[0,default] $salloc_default_command = '',
  Hash[Enum['DestDir','Compression'],String[1,default]] $sbcast_parameters = {},
  String[1,default] $slurmctld_pid_file = '/var/run/slurmctld.pid',
  Array[String[1,default]] $slurmctld_plugstack = [],
  Integer[1,default] $slurmctld_port= 6817,
  String[1,default] $slurmd_pid_file = '/var/run/slurmd.pid',
  Array[String[1,default]] $slurmd_plugstack = [],
  Integer[1,default] $slurmd_port = 6818,
  String[1,default] $slurmd_spool_dir = '/var/spool/slurmd',
  String[1,default] $slurm_user = 'root',
  String[1,default] $slurmd_user = 'root',
  String[0,default] $srun_epilog = '',
  String[0,default] $srun_prolog = '',
  String[0,default] $srun_port_range = '',
  String[1,default] $state_save_location = '/var/spool',
  Enum['switch/none','switch/nrt'] $switch_type = 'switch/none',
  Array[Enum['task/affinity','task/cgroup','task/none']] $task_plugin = ['task/none'],
  Array[Enum['Boards','Cores','Cpusets','None','Sched','Sockets','Threads','Verbose','Autobind']] $task_plugin_param = ['Sched'],
  String[0,default] $task_epilog = '',
  String[0,default] $task_prolog = '',
  Integer[1,default] $tcp_timeout = 2,
  String[1,default] $tmp_fs = '/tmp',
  Enum['no','yes'] $track_wckey = 'no',
  String[0,default] $unkillable_step_program = '',

  Enum['auth/none','auth/munge'] $auth_type = 'auth/munge',
  String[0,default] $auth_info = '',
  Enum['crypto/munge','crypto/openssl'] $crypto_type = 'crypto/munge',
  String[0,default] $job_credential_private_key = '',
  String[0,default] $job_credential_public_certificate = '',
  Enum['mcs/account','mcs/group','mcs/none','mcs/user'] $mcs_plugin = 'mcs/none',
  String[0,default] $mcs_parameters = '',
  Integer[0,1] $use_pam = 0,

  Integer[0,default] $batch_start_timeout = 10,
  Integer[0,default] $complete_wait = 0,
  Integer[0,default] $eio_timeout = 60,
  Integer[0,default] $epilog_msg_time = 2000,
  Integer[0,default] $get_env_timeout = 2,
  Integer[0,default] $group_update_time = 600,
  Integer[0,default] $inactive_limit = 0,
  Integer[0,default] $keep_alive_time = 0,
  Integer[0,default] $kill_wait = 30,
  Integer[0,default] $message_timeout = 10,
  Integer[2,default] $min_job_age = 300,
  Integer[0,default] $over_time_limit = 0,
  Integer[0,default] $prolog_epilog_timeout = 0,
  Integer[0,default] $resv_over_run = 0,
  Integer[0,default] $slurmctld_timeout = 120,
  Integer[0,default] $slurmd_timeout = 300,
  Integer[0,default] $unkillable_step_timeout = 60,
  Integer[0,default] $wait_time = 0,

  Integer[0,default] $def_mem_per_cpu = 0,
  Integer[0,default] $def_mem_per_node = 0,
  String[0,default] $epilog = '',
  String[0,default] $epilog_slurmctld = '',
  Integer[0,2] $fast_schedule = 1,
  Integer[0,default] $max_array_size = 1001,
  Integer[0,default] $max_mem_per_cpu = 0,
  Integer[0,default] $max_mem_per_node = 0,
  Integer[0,default] $max_tasks_per_node = 512,
  Enum['lam','mpich1_p4','mpich1_shmem','mpichgm','mpichmx','mvapich','none','openmpi','pmi2'] $mpi_default = 'none',
  Hash[Enum['ports'],String[1,default]] $mpi_params = {},
  String[0,default] $prolog_slurmctld = '',
  String[0,default] $prolog = '',
  Array[Enum['Alloc','Contain','NoHold']] $prolog_flags = [],
  String[0,default] $requeue_exit = '',
  String[0,default] $requeue_exit_hold = '',
  Integer[0,default] $scheduler_time_slice = 30,
  Enum['sched/backfill','sched/builtin','sched/hold'] $scheduler_type = 'sched/backfill',
  Array[String[1,default]] $scheduler_parameters = [],
  Enum['select/bluegene','select/cons_res','select/cray','select/linear','select/serial'] $select_type = 'select/linear',
  Enum['OTHER_CONS_RES','NHC_ABSOLUTELY_NO','NHC_NO_STEPS','NHC_NO','CR_CPU','CR_CPU_Memory','CR_Core','CR_Core_Memory','CR_ONE_TASK_PER_CORE','CR_CORE_DEFAULT_DIST_BLOCK','CR_LLN','CR_Pack_Nodes','CR_Socket','CR_Socket_Memory','CR_Memory',''] $select_type_parameters = '',
  Integer[0,default] $vsize_factor = 0,

  Enum['priority/basic','priority/multifactor'] $priority_type = 'priority/basic',
  Array[Enum['ACCRUE_ALWAYS','CALCULATE_RUNNING','DEPTH_OBLIVIOUS','FAIR_TREE','INCR_ONLY','MAX_TRES','SMALL_RELATIVE_TO_TIME']] $priority_flags = [],
  Integer[0,default] $priority_calc_period = 5,
  String[0,default] $priority_decay_half_life = '7-0',
  Enum['NO','YES'] $priority_favor_small = 'NO',
  String[0,default] $priority_max_age = '7-0',
  Enum['NONE','NOW','DAILY','WEEKLY','MONTHLY','QUARTERLY','YEARLY'] $priority_usage_reset_period = 'NONE',
  Integer[0,default] $priority_weight_age = 0,
  Integer[0,default] $priority_weight_fairshare = 0,
  Integer[0,default] $fair_share_dampening_factor = 1,
  Integer[0,default] $priority_weight_job_size = 0,
  Integer[0,default] $priority_weight_partition = 0,
  Integer[0,default] $priority_weight_qos = 0,
  Hash[String[1,default],Integer[0,default]] $priority_weight_tres = {},

  String[0,default] $cluster_name = '',
  String[0,default] $default_storage_host = '',
  Integer[0,default] $default_storage_port = 6819,
  String[0,default] $default_storage_type = '',
  String[0,default] $default_storage_user = '',
  String[0,default] $default_storage_pass = '',
  String[0,default] $default_storage_loc = '',
  String[0,default] $accounting_storage_host = '',
  String[0,default] $accounting_storage_backup_host = '',
  Integer[0,default] $accounting_storage_port = 6819,
  String[0,default] $accounting_storage_enforce = '',
  Array[String[1,default]] $accounting_storage_tres = [],
  Enum['accounting_storage/filetxt','accounting_storage/mysql','accounting_storage/none','accounting_storage/slurmdbd'] $accounting_storage_type = 'accounting_storage/none',
  String[0,default] $accounting_storage_user = '',
  String[0,default] $accounting_storage_pass = '',
  String[0,default] $accounting_storage_loc = '',
  Enum['NO','YES'] $accounting_store_jobhost = 'YES',
  Enum['jobcomp/none','jobcomp/elasticsearch','jobcomp/filetxt','jobcomp/mysql','jobcomp/script'] $job_comp_type = 'jobcomp/none',
  String[0,default] $job_comp_host = '',
  Integer[0,default] $job_comp_port = 6819,
  String[0,default] $job_comp_user = '',
  String[0,default] $job_comp_pass = '',
  String[0,default] $job_comp_loc = '',
  Enum['jobacct_gather/linux','jobacct_gather/cgroup','jobacct_gather/none'] $job_acct_gather_type = 'jobacct_gather/none',
  Array[Enum['NoShared','UsePss','NoOverMemoryKill']] $job_acct_gather_params = [],
  Hash[Enum['task','energy','network','filesystem'],Integer[0,default]] $job_acct_gather_frequency = {'task' => 30,'energy' => 0,'network' => 0,'filesystem' => 0},
  Integer[0,default] $acct_gather_node_freq = 0,
  Enum['acct_gather_energy/none','acct_gather_energy/ipmi','acct_gather_energy/rapl'] $acct_gather_energy_type = 'acct_gather_energy/none',
  Enum['acct_gather_infiniband/none','acct_gather_infiniband/ofed'] $acct_gather_infiniband_type = 'acct_gather_infiniband/none',
  Enum['acct_gather_filesystem/none','acct_gather_filesystem/lustre'] $acct_gather_filesystem_type = 'acct_gather_filesystem/none',
  Enum['acct_gather_profile/none','acct_gather_profile/hdf5'] $acct_gather_profile_type = 'acct_gather_profile/none',

  Array[String[1,default]] $debug_flags = [],
  Enum['iso8601','iso8601_ms','rfc5424','rfc5424_ms','clock','short'] $log_time_format = 'iso8601_ms',
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $slurmctld_debug = 'info',
  String[0,default] $slurmctld_log_file = '',
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $slurmd_debug = 'info',
  String[0,default] $slurmd_log_file = '',
  Integer[0,1] $slurm_sched_log_level = 0,
  String[0,default] $slurm_sched_log_file = '',

  String[0,default] $health_check_program = '',
  Enum['ALLOC','ANY','CYCLE','IDLE','MIXED'] $health_check_node_state = 'ANY',
  Integer[0,default] $health_check_interval = 0,

  String[0,default] $suspend_program = '',
  Integer[0,default] $suspend_timeout = 30,
  Integer[0,default] $suspend_rate = 60,
  Integer[-1,default] $suspend_time = -1,
  String[0,default] $suspend_exc_nodes = '',
  String[0,default] $suspend_exc_parts = '',
  String[0,default] $resume_program = '',
  Integer[0,default] $resume_timeout = 60,
  Integer[0,default] $resume_rate = 300,

  Enum['topology/3d_torus','topology/node_rank','topology/none','topology/tree'] $topology_plugin= 'topology/none',
  Array[Enum['Dragonfly','NoCtldInAddrAny','NoInAddrAny','TopoOptional']] $topology_param = ['NoCtldInAddrAny','NoInAddrAny'],
  Enum['route/default','route/topology'] $route_plugin = 'route/default',
  Integer[1,default] $tree_width = 50,

  Array[Hash] $workernodes = [{
    'NodeName' => 'worker[00-10]',
    'CPUs' => '16',
  }],
  Array[Hash] $partitions = [{
    'PartitionName' => 'workers',
    'MaxMemPerCPU' => '2000',
  }],
)
```
The configuration class, common to all types of nodes, is responsible to create the main slurm.conf configuration file. For more details about each parameter, please refer to the [SLURM documentation](https://slurm.schedmd.com/slurm.conf.html). Almost all default values are taken from SLURM's official documentation, except the control_machine, the workernodes and the partitions; they are provided as an example.


### slurm::config::acct_gather
```ruby
class slurm::config::acct_gather (
  Boolean $with_energy_ipmi = false,
  Integer[0,default] $energy_ipmi_frequency = 10,
  Enum['no','yes'] $energy_ipmi_calc_adjustment = 'no',
  Hash[String,String] $energy_ipmi_power_sensors = {},
  String[0,default] $energy_ipmi_username = '',
  String[0,default] $energy_ipmi_password = '',
  Boolean $with_profile_hdf5 = false,
  String[0,default] $profile_hdf5_dir = '',
  String[1,default] $profile_hdf5_default = 'None',
  Boolean $with_infiniband_ofed = false,
  Integer[0,default] $infiniband_ofed_port = 1,
)
```
The acct_gather class is responsible to create the configuration file used by the AcctGather type plugins, namely EnergyIPMI, ProfileHDF5 and InfinibandOFED. Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/acct_gather.conf.html) in the SLURM documentation.


### slurm::config::cgroup
```ruby
class slurm::config::cgroup (
  Enum['no','yes'] $cgroup_automount = 'no',
  String[1,default] $cgroup_mountpoint = '/sys/fs/cgroup',
  Enum['no','yes'] $constrain_cores = 'no',
  Enum['no','yes'] $task_affinity = 'no',
  Enum['no','yes'] $constrain_ram_space = 'no',
  Float[0,100] $allowed_ram_space = 100.0,
  Float[0,default] $min_ram_space = 30.0,
  Float[0,100] $max_ram_percent = 100.0,
  Enum['no','yes'] $constrain_swap_space = 'no',
  Float[0,100] $allowed_swap_space = 0.0,
  Float[0,100] $max_swap_percent = 100.0,
  Enum['no','yes'] $constrain_kmem_space = 'yes',
  Float[0,100] $allowed_kmem_space = 1.0,
  Float[0,default] $min_kmem_space = 30.0,
  Float[0,100] $max_kmem_percent = 100.0,
  Enum['no','yes'] $constrain_devices = 'no',
  String[1,default] $allowed_devices_file = '/etc/slurm/cgroup_allowed_devices_file.conf',
)
```
The cgroup class is responsible to create the configuration file used by all the plugins using cgroups, namely proctrack/cgroup, task/cgroup and jobacct_gather/cgroup. Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/cgroup.conf.html) in the SLURM documentation.

### slurm::config::topology
```ruby
class slurm::config::topology (
  Array[Hash[String, String]] $switches = [{
    'SwitchName' => 's0',
    'Nodes' => 'worker[00-10]',
  }],
)
```
The topology class is responsible to create the configuration file used by all the plugins using topology, namely topology/tree and route/topology. Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/topology.conf.html) in the SLURM documentation.

## slurm::dbnode
```ruby
class slurm::dbnode ()
```
The database class is responsible to call the database specific setup, firewall and configure class.

### slurm::dbnode::setup
```ruby
class slurm::dbnode::setup (
  String[1,default] $slurmdbd_log_file = '/var/log/slurm/slurmdbd.log',
  Array[String] $packages = [
    'slurm-plugins',
    'slurm-slurmdbd',
    'slurm-sql',
  ],
)
```
The database setup class is responsible to install the necessary packages and create all the necessary folders and files for the dbnode to work.

### slurm::dbnode::config
```ruby
class slurm::dbnode::config (
  String[1,default] $file_name = 'slurmdbd.conf',
  String[1,default] $dbd_host = 'localhost',
  String[1,default] $dbd_addr = $dbd_host,
  String[0,default] $dbd_backup_host = '',
  Integer[0,default] $dbd_port = $slurm::config::accounting_storage_port,
  Enum['auth/none','auth/munge'] $auth_type = 'auth/none',
  String[0,default] $auth_info = '',
  String[0,default] $default_qos = '',
  Integer[0,default] $message_timeout = 10,
  String[1,default] $pid_file = '/var/run/slurmdbd.pid',
  String[1,default] $plugin_dir = '/usr/local/lib/slurm' ,
  String[0,default] $private_data = '',
  String[1,default] $slurm_user = $slurm::config::slurm_user,
  Integer[0,default] $tcp_timeout = 2,
  Enum['no','yes'] $track_wc_key = 'no',
  Enum['no','yes'] $track_slurmctld_down = 'no',
  Enum['accounting_storage/mysql'] $storage_type = 'accounting_storage/mysql',
  String[1,default] $storage_host = 'db_instance.example.org',
  String[0,default] $storage_backup_host = '',
  Integer[0,default] $storage_port = 1234,
  String[1,default] $storage_user = 'user',
  String[1,default] $storage_pass = 'CHANGEME__storage_pass',
  String[1,default] $storage_loc = 'accountingdb',
  String[1,default] $archive_dir = '/tmp',
  String[0,default] $archive_script = '',
  Enum['no','yes'] $archive_events = 'no',
  String[0,default] $purge_event_after = '',
  Enum['no','yes'] $archive_jobs = 'no',
  String[0,default] $purge_job_after = '',
  Enum['no','yes'] $archive_resvs = 'no',
  String[0,default] $purge_resv_after = '',
  Enum['no','yes'] $archive_steps = 'no',
  String[0,default] $purge_step_after = '',
  Enum['no','yes'] $archive_suspend = 'no',
  String[0,default] $purge_suspend_after = '',
  Enum['no','yes'] $archive_txn = 'no',
  String[0,default] $purge_txnafter = '',
  Enum['no','yes'] $archive_usage = 'no',
  String[0,default] $purge_usage_after = '',
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $debug_level = 'info',
  Array[Enum['DB_ARCHIVE','DB_ASSOC','DB_EVENT','DB_JOB','DB_QOS','DB_QUERY','DB_RESERVATION','DB_RESOURCE','DB_STEP','DB_USAGE','DB_WCKEY']] $debug_flags = [],
  String[0,default] $log_file = '',
  Enum['iso8601','iso8601_ms','rfc5424','rfc5424_ms','clock','short'] $log_time_format = 'iso8601_ms',
)
```
The database configuration class is responsible to create the configuration file for the dbnode and start the slurmdbd daemon.


### slurm::dbnode::firewall
```ruby
class slurm::dbnode::firewall ()
```
The database firewall class is responsible to open the slurmdbd port defined in the main configuration class.


## slurm::headnode
```ruby
class slurm::headnode ()
```
The headnode class is responsible to call the headnode specific setup, firewall and configure class.


### slurm::headnode::setup
```ruby
class slurm::headnode::setup (
  String[1,default] $slurmctld_spool_dir = '/var/spool/slurmctld',
  String[1,default] $state_save_location = '/var/spool/slurmctld/slurm.state',
  String[1,default] $slurmctld_log_file = '/var/log/slurm/slurmctld.log',
  Array[String] $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-torque',
  ],
)
```
The headnode setup class is responsible to install the necessary packages and create all the necessary folders and files for the headnode to work.


### slurm::headnode::config
```ruby
class slurm::headnode::config ()
```
The headnode configuration class is responsible to start the slurmctld daemon.


### slurm::headnode::firewall
```ruby
class slurm::headnode::firewall ()
```
The headnode firewall class is responsible to open the slurmctld port defined in the main configuration class.


## slurm::workernode
```ruby
class slurm::workernode ()
```
The workernode class is responsible to call the workernode specific setup, firewall and configure class.


### slurm::workernode::setup
```ruby
class slurm::workernode::setup (
  String[1,default] $slurmd_spool_dir = '/var/spool/slurmd',
  String[1,default] $slurmd_log_file = '/var/log/slurm/slurmd.log',
  Array[String] $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-torque',
  ],
)
```
The workernode setup class is responsible to install the necessary packages and create all the necessary folders and files for the workernode to work.


### slurm::workernode::config
```ruby
class slurm::workernode::config ()
```
The workernode configuration class is responsible to start the slurmd daemon.


### slurm::workernode::firewall
```ruby
class slurm::workernode::firewall ()
```
The workernode firewall class is responsible to open the slurmd port defined in the main configuration class.


## Files

### acct_gather.conf.erb
TODO

### cgroup.conf.erb
TODO

### job_stuck_alert.sh.erb
TODO

### plugstack.conf.erb
TODO

### slurm.conf.erb
TODO

### slurmdbd.conf.erb
TODO

### topology.conf.erb
TODO

# Limitations

It is tested and working on Centos 7.2/7.3 with Puppet 4.8.1. Not working with Puppet 3!


# Development

The future task which needs to be done is testing any new versions of SLURM and checking if the current module still supports the latest features.

As always, changes should be done in a new branch first for testing and then a merged to qa using a merge request. Once the module is validated in qa for at least one week, the changes can be merged into master.

Please document all changes in the CHANGELOG and update this README if necessary!

# Contributors

  * Philippe Ganz (CERN) as creator and main maintainer
  * Carolina Lindqvist (CERN) as creator and main maintainer
