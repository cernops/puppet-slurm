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
2. [Structure] (#structure)
3. [Usage](#usage)
    * [Requirements](#requirements-for-usage-at-cern)
    * [Beginning with slurm](#beginning-with-slurm)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [What slurm affects](#what-slurm-affects)
    * [Class references] (#class-references)
6. [Limitations](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors](#contributors)

# Description

This module installs the SLURM scheduler for running parallel programs on an HPC cluster.

This module sets up, configures and installs all required binaries and configuration files. All the configuration parameters come from Hiera data, and therefore actual class parameters have been kept to a bare minimum.
Jump [here](#beginning-with-slurm) for a quickstart. 

This module supports and has been tested on Redhat-based systems and works out of the box on CentOS 7. Patches for other distributions are welcome.

# Structure

The module's class structure is described next. This is useful to the user to know which parameters go where in the class namespace.

Please note that since this module supports over 300 parameters, these have not been arranged in the traditional fashion of having init.pp take all parameters and have them trickle down the hierarchy, but the parameters to each class has to be set through Hiera.

- The main class *slurm* `::slurm` only takes one parameter, `node_type`, which maps to the node's role in the slurm cluster. This value can be either `head`, `worker`, `db`, `db-head` (for db+head) or `none`.
  - The *setup* `slurm::setup` class contains some packages, directories, user names, uid and guid that are necessary before the actual installation and configuration.
  - The *config* class `slurm::config` holds all the parameters available for various configuration files. All the parameter names map to those of the slurm documentation. This class also takes care of installing and configuring munge depending on the authentication method parameter.
  - There are also role-specific config and setup classes; e.g. slurm::dbnode::config, slurm::workernode::setup. These contain role-specific parameters that can also be set through Hiera. These classes will take care of setting up and configuring necessary services for each role.


# Usage 

## Requirements for usage at CERN

This package should provide everything necessary for most SLURM deployments.

If you use this module at CERN, it needs to be enabled in the pluginsync filter :
```yaml
# my_hostgroup.yaml

# enabling the slurm module
pluginsync_filter:
 - slurm

```

## Beginning with slurm

This Section provides examples for a minimal configuration to get started with a basic setup.

To use the module, first include it in your hostgroup manifest :
```yaml
# my_hostgroup.pp

# including slurm to be able to do some awesome scheduling on HPC machines
include ::slurm

# Put my secret mungekey on all the machine for the MUNGE security plugin
# You can generate the content using `dd if=/dev/random bs=1 count=1024 >/etc/munge/munge.key`
file{ '/etc/munge/munge.key':
  ensure  => file,
  content => 'YourIncrediblyStrongSymmetricKey',
  owner   => 'munge',
  group   => 'munge',
  mode    => '0400',
}

```
and then make sure you have all the necessary configuration options in data; without any Hiera data, the module will *not* work, puppet will trigger a warning and nothing will be installed and/or configured.

The following minimal configuration is required for the module to work, i.e. you need a master controller, at least one workernode and a partition containing the nodes.
```yaml
# my_hostgroup.yaml

slurm::config::control_machine: slurm-master.yourdomain.com   # Only one controller is needed, backup is optional
slurm::config::plugin_dir: /usr/lib64/slurm                   # Path to your SLURM installation
slurm::config::open_firewall: true                            # Open the SLURM ports using the puppet firewall module

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
```

You also need to specify on the sub-hostgroups which type the node should be in the slurm configuration, e.g. head, worker or database node.
```yaml
# my_hostgroup/head.yaml

slurm::node_type: head
```

```yaml
# my_hostgroup/worker.yaml

slurm::node_type: worker
```


# References

## What slurm affects

### Packages installed by the module

To avoid version conflicts, the following packages will be installed/replaced by the module in its default setup. You can override those lists in the setup classes if some packages are unnecessary/missing for your configuration, e.g. slurm-auth-none, slurm-pam_slurm, etc...

#### On all types of nodes
```ruby
- 'slurm',
- 'slurm-devel',
- 'slurm-munge',
- 'slurm-plugins',
- 'munge',
- 'munge-libs',
- 'munge-devel',
```

#### On the database nodes
```ruby
- 'slurm-slurmdbd',
- 'slurm-sql',
```

#### On the headnodes
```ruby
- 'slurm-perlapi',
- 'slurm-torque',
```

#### On the worker nodes
```ruby
- 'slurm-perlapi',
- 'slurm-torque',
```

### Dependencies

#### Authentication
The default (and only supported) authentication mechanism for SLURM is [MUNGE](https://dun.github.io/munge/). It is set in the configuration file `slurm.conf` as follows:
```
AuthType=auth/munge
```
Another alternative for this value is `auth/none` which requires the `auth-none` plugin to be built as part of SLURM. It is recommended to use MUNGE rather than unauthenticated communication.

#### Database configuration
The database for SLURM is used solely for accounting purposes. The module supports a setup with a database node either separate from or combined with a headnode. The database configuration is done in the [dbnode](manifests/dbnode) manifests.

The main configuration values correspond with the ones defined in [slurm.conf](#slurm.conf.erb) and [slurmdbd.conf](#slurmdbd.conf.erb). You should set `$accounting_storage_type` to suit your preferences. It is set to `accounting_storage/none` by default, and in this case no database configuration is required. Otherwise, you should consider setting the following parameters as well:
```ruby
# class slurm::config
String $accounting_storage_host     # slurm.conf AccountingStorageHost
String $accounting_storage_loc      # slurm.conf AccountingStorageLoc
String $accounting_storage_pass     # slurm.conf AccountingStoragePass
Integer $accounting_storage_port    # slurm.conf AccountingStoragePort [Default: 6819].
String $accounting_storage_user     # slurm.conf AccountingStorageUser
String $job_acct_gather_frequency   # slurm.conf JobAcctGatherFrequency [Default: {'task' => 30,'energy' => 0,'network' => 0,'filesystem' => 0}].

# class slurm::dbnode::config
String $dbd_host      # slurmdb.conf DbdHost [Default: 'localhost'].
Integer $dbd_port     # slurmdb.conf DbdPort [Default: 6819].
String $storage_host  # slurmdb.conf StorageHost
Integer $storage_port # slurmdb.conf StoragePort [Default: 1234].
String $storage_user  # slurmdb.conf StorageUser [Default: 'slurm'].
String $storage_loc   # slurmdb.conf StorageLoc [Default: 'accountingdb'].
```

If the database is running on a headnode, and locally, the hostnames can be set as `localhost`.
Further information can be found in the [official documentation](https://slurm.schedmd.com/accounting.html).


### Version

Currently, the module is configured to match versions 17.02.X. It has been tested and works with version 17.02.6.

## Class references
### slurm
```ruby
class slurm (
  Enum['worker','head','db','db-head','none'] $node_type,
)
```
The main class is responsible to call the relevant node type classes according to node_type parameter or to warn the user that he did not specify any node type.


### slurm::setup
```ruby
class slurm::setup (
  String $slurm_version = '17.02.6',
  Integer[0] $slurm_gid = 950,
  Integer[0] $slurm_uid = 950,
  String $slurm_home_loc = '/usr/local/slurm',
  String $slurm_log_file = '/var/log/slurm',
  String $slurm_plugstack_loc = '/etc/slurm/plugstack.conf.d',
)
```
The setup class, common to all types of nodes, is responsible to set up all the folders and keys needed by SLURM to work correctly. For more details about each parameter, please refer to the header of [setup.pp](manifest/setup.pp).


### slurm::config
```ruby
class slurm::config (
  String $control_machine,
  String $control_addr = $control_machine,
  Optional[String] $backup_controller = undef,
  Optional[String] $backup_addr = $backup_controller,
  Integer[0,1] $allow_spec_resources_usage = 0,
  Enum['checkpoint/blcr','checkpoint/none','checkpoint/ompi','checkpoint/poe'] $checkpoint_type= 'checkpoint/none',
  Optional[String] $chos_loc = undef,
  Enum['core_spec/cray','core_spec/none'] $core_spec_plugin = 'core_spec/none',
  Enum['Conservative','OnDemand','Performance','PowerSave'] $cpu_freq_def = 'Performance',
  Array[Enum['Conservative','OnDemand','Performance','PowerSave','UserSpace']] $cpu_freq_governors = ['OnDemand','Performance'],
  Enum['NO','YES'] $disable_root_jobs = 'NO',
  Enum['NO','YES'] $enforce_part_limits = 'NO',
  Enum['ext_sensors/none','ext_sensors/rrd'] $ext_sensors_type = 'ext_sensors/none',
  Integer[0] $ext_sensors_freq = 0,
  Integer[1] $first_job_id = 1,
  Integer[1] $max_job_id = 999999,
  Optional[Array[String]] $gres_types = undef,
  Integer[0,1] $group_update_force = 0,
  String $job_checkpoint_dir = '/var/slurm/checkpoint',
  Enum['job_container/cncu','job_container/none'] $job_container_type = 'job_container/none',
  Integer[0,1] $job_file_append = 0,
  Integer[0,1] $job_requeue = 0,
  Optional[Array[String]] $job_submit_plugins = undef,
  Integer[0,1] $kill_on_bad_exit = 0,
  Enum['launch/aprun','launch/poe','launch/runjob','launch/slurm'] $launch_type = 'launch/slurm',
  Optional[Array[Enum['mem_sort','slurmstepd_memlock','slurmstepd_memlock_all','test_exec']]] $launch_parameters = undef,
  Optional[Array[String]] $licenses = undef,
  Optional[Enum['node_features/knl_cray','node_features/knl_generic']] $node_features_plugins = undef,
  String $mail_prog = '/bin/mail',
  Optional[String] $mail_domain = undef,
  Integer[1] $max_job_count = 10000,
  Integer[1] $max_step_count = 40000,
  Enum['no','yes'] $mem_limit_enforce = 'yes',
  Hash[Enum['WindowMsgs','WindowTime'],Integer[1]] $msg_aggregation_params = {'WindowMsgs' => 1, 'WindowTime' => 100},
  String $plugin_dir = '/usr/local/lib/slurm',
  Optional[String] $plug_stack_config = undef,
  Enum['power/cray','power/none'] $power_plugin = 'power/none',
  Optional[Array[String]] $power_parameters = undef,
  Enum['preempt/none','preempt/partition_prio','preempt/qos'] $preempt_type = 'preempt/none',
  Array[Enum['OFF','CANCEL','CHECKPOINT','GANG','REQUEUE','SUSPEND']] $preempt_mode = ['OFF'],
  Optional[Array[Enum['accounts','cloud','jobs','nodes','partitions','reservations','usage','users']]] $private_data = undef,
  Optional[Enum['proctrack/cgroup','proctrack/cray','proctrack/linuxproc','proctrack/lua','proctrack/sgi_job','proctrack/pgid']] $proctrack_type = undef,
  Integer[0,2] $propagate_prio_process = 0,
  Optional[Array[Enum['ALL','NONE','AS','CORE','CPU','DATA','FSIZE','MEMLOCK','NOFILE','NPROC','RSS','STACK']]] $propagate_resource_limits = undef,
  Optional[Array[Enum['ALL','NONE','AS','CORE','CPU','DATA','FSIZE','MEMLOCK','NOFILE','NPROC','RSS','STACK']]] $propagate_resource_limits_except = undef,
  String $reboot_program = '/usr/sbin/reboot',
  Optional[Enum['KeepPartInfo','KeepPartState']] $reconfig_flags = undef,
  Optional[String] $resv_epilog = undef,
  Optional[String] $resv_prolog = undef,
  Integer[0,2] $return_to_service = 0,
  Optional[String] $salloc_default_command = undef,
  Optional[Hash[Enum['DestDir','Compression'],String]] $sbcast_parameters = undef,
  String $slurmctld_pid_file = '/var/run/slurmctld.pid',
  Optional[Array[String]] $slurmctld_plugstack = undef,
  Integer[1] $slurmctld_port = 6817,
  String $slurmd_pid_file = '/var/run/slurmd.pid',
  Optional[Array[String]] $slurmd_plugstack = undef,
  Integer[1] $slurmd_port = 6818,
  String $slurmd_spool_dir = '/var/spool/slurmd',
  String $slurm_user = 'root',
  String $slurmd_user = 'root',
  Optional[String] $srun_epilog = undef,
  Optional[String] $srun_prolog = undef,
  Optional[String] $srun_port_range = undef,
  String $state_save_location = '/var/spool/slurmctld',
  Enum['switch/none','switch/nrt'] $switch_type = 'switch/none',
  Array[Enum['task/affinity','task/cgroup','task/none']] $task_plugin = ['task/none'],
  Array[Enum['Boards','Cores','Cpusets','None','Sched','Sockets','Threads','Verbose','Autobind']] $task_plugin_param = ['Sched'],
  Optional[String] $task_epilog = undef,
  Optional[String] $task_prolog = undef,
  Integer[1] $tcp_timeout = 2,
  String $tmp_fs = '/tmp',
  Enum['no','yes'] $track_wckey = 'no',
  Optional[String] $unkillable_step_program = undef,

  Enum['auth/none','auth/munge'] $auth_type = 'auth/munge',
  Optional[String] $auth_info = undef,
  Enum['crypto/munge','crypto/openssl'] $crypto_type = 'crypto/munge',
  Optional[String] $job_credential_private_key = undef,
  Optional[String] $job_credential_public_certificate = undef,
  Enum['mcs/account','mcs/group','mcs/none','mcs/user'] $mcs_plugin = 'mcs/none',
  Optional[String] $mcs_parameters = undef,
  Integer[0,1] $use_pam = 0,
  String $munge_version = '0.5.11',
  Integer[0] $munge_gid = 951,
  Integer[0] $munge_uid = 951,
  String $munge_loc = '/etc/munge',
  String $munge_log_file = '/var/log/munge',
  String $munge_home_loc = '/var/lib/munge',
  String $munge_run_loc = '/run/munge',

  Integer[0] $batch_start_timeout = 10,
  Integer[0] $complete_wait = 0,
  Integer[0] $eio_timeout = 60,
  Integer[0] $epilog_msg_time = 2000,
  Integer[0] $get_env_timeout = 2,
  Integer[0] $group_update_time = 600,
  Integer[0] $inactive_limit = 0,
  Integer[0] $keep_alive_time = 0,
  Integer[0] $kill_wait = 30,
  Integer[0] $message_timeout = 10,
  Integer[2] $min_job_age = 300,
  Integer[0] $over_time_limit = 0,
  Integer[0] $prolog_epilog_timeout = 0,
  Integer[0] $resv_over_run = 0,
  Integer[0] $slurmctld_timeout = 120,
  Integer[0] $slurmd_timeout = 300,
  Integer[0] $unkillable_step_timeout = 60,
  Integer[0] $wait_time = 0,

  Integer[0] $def_mem_per_cpu = 0,
  Integer[0] $def_mem_per_node = 0,
  Optional[String] $epilog = undef,
  Optional[String] $epilog_slurmctld = undef,
  Integer[0,2] $fast_schedule = 1,
  Integer[0] $max_array_size = 1001,
  Integer[0] $max_mem_per_cpu = 0,
  Integer[0] $max_mem_per_node = 0,
  Integer[0] $max_tasks_per_node = 512,
  Enum['lam','mpich1_p4','mpich1_shmem','mpichgm','mpichmx','mvapich','none','openmpi','pmi2'] $mpi_default = 'none',
  Optional[Hash[Enum['ports'],String]] $mpi_params = undef,
  Optional[String] $prolog_slurmctld = undef,
  Optional[String] $prolog = undef,
  Optional[Array[Enum['Alloc','Contain','NoHold']]] $prolog_flags = undef,
  Optional[String] $requeue_exit = undef,
  Optional[String] $requeue_exit_hold = undef,
  Integer[0] $scheduler_time_slice = 30,
  Enum['sched/backfill','sched/builtin','sched/hold'] $scheduler_type = 'sched/backfill',
  Optional[Array[String]] $scheduler_parameters = undef,
  Enum['select/bluegene','select/cons_res','select/cray','select/linear','select/serial'] $select_type = 'select/linear',
  Optional[Enum['OTHER_CONS_RES','NHC_ABSOLUTELY_NO','NHC_NO_STEPS','NHC_NO','CR_CPU','CR_CPU_Memory','CR_Core','CR_Core_Memory','CR_ONE_TASK_PER_CORE','CR_CORE_DEFAULT_DIST_BLOCK','CR_LLN','CR_Pack_Nodes','CR_Socket','CR_Socket_Memory','CR_Memory']] $select_type_parameters = undef,
  Integer[0] $vsize_factor = 0,

  Enum['priority/basic','priority/multifactor'] $priority_type = 'priority/basic',
  Optional[Array[Enum['ACCRUE_ALWAYS','CALCULATE_RUNNING','DEPTH_OBLIVIOUS','FAIR_TREE','INCR_ONLY','MAX_TRES','SMALL_RELATIVE_TO_TIME']]] $priority_flags = undef,
  Integer[0] $priority_calc_period = 5,
  String $priority_decay_half_life = '7-0',
  Enum['NO','YES'] $priority_favor_small = 'NO',
  String $priority_max_age = '7-0',
  Enum['NONE','NOW','DAILY','WEEKLY','MONTHLY','QUARTERLY','YEARLY'] $priority_usage_reset_period = 'NONE',
  Integer[0] $priority_weight_age = 0,
  Integer[0] $priority_weight_fairshare = 0,
  Integer[0] $fair_share_dampening_factor = 1,
  Integer[0] $priority_weight_job_size = 0,
  Integer[0] $priority_weight_partition = 0,
  Integer[0] $priority_weight_qos = 0,
  Optional[Hash[String,Integer[0]]] $priority_weight_tres = undef,

  String $cluster_name,
  Optional[String] $default_storage_host = undef,
  Integer[0] $default_storage_port = 6819,
  Optional[String] $default_storage_type = undef,
  Optional[String] $default_storage_user = undef,
  Optional[String] $default_storage_pass = undef,
  Optional[String] $default_storage_loc = undef,
  Optional[String] $accounting_storage_host = undef,
  Optional[String] $accounting_storage_backup_host = undef,
  Integer[0] $accounting_storage_port = 6819,
  Optional[String] $accounting_storage_enforce = undef,
  Optional[Array[String]] $accounting_storage_tres = undef,
  Enum['accounting_storage/filetxt','accounting_storage/mysql','accounting_storage/none','accounting_storage/slurmdbd'] $accounting_storage_type = 'accounting_storage/none',
  Optional[String] $accounting_storage_user = undef,
  Optional[String] $accounting_storage_pass = undef,
  Optional[String] $accounting_storage_loc = undef,
  Enum['NO','YES'] $accounting_store_jobhost = 'YES',
  Enum['jobcomp/none','jobcomp/elasticsearch','jobcomp/filetxt','jobcomp/mysql','jobcomp/script'] $job_comp_type = 'jobcomp/none',
  Optional[String] $job_comp_host = undef,
  Integer[0] $job_comp_port = 6819,
  Optional[String] $job_comp_user = undef,
  Optional[String] $job_comp_pass = undef,
  Optional[String] $job_comp_loc = undef,
  Enum['jobacct_gather/linux','jobacct_gather/cgroup','jobacct_gather/none'] $job_acct_gather_type = 'jobacct_gather/none',
  Optional[Array[Enum['NoShared','UsePss','NoOverMemoryKill']]] $job_acct_gather_params = undef,
  Hash[Enum['task','energy','network','filesystem'],Integer[0]] $job_acct_gather_frequency = {'task' => 30,'energy' => 0,'network' => 0,'filesystem' => 0},
  Integer[0] $acct_gather_node_freq = 0,
  Enum['acct_gather_energy/none','acct_gather_energy/ipmi','acct_gather_energy/rapl'] $acct_gather_energy_type = 'acct_gather_energy/none',
  Enum['acct_gather_infiniband/none','acct_gather_infiniband/ofed'] $acct_gather_infiniband_type = 'acct_gather_infiniband/none',
  Enum['acct_gather_filesystem/none','acct_gather_filesystem/lustre'] $acct_gather_filesystem_type = 'acct_gather_filesystem/none',
  Enum['acct_gather_profile/none','acct_gather_profile/hdf5'] $acct_gather_profile_type = 'acct_gather_profile/none',

  Optional[Array[String]] $debug_flags = undef,
  Enum['iso8601','iso8601_ms','rfc5424','rfc5424_ms','clock','short'] $log_time_format = 'iso8601_ms',
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $slurmctld_debug = 'info',
  Optional[String] $slurmctld_log_file = undef,
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $slurmd_debug = 'info',
  Optional[String] $slurmd_log_file = undef,
  Integer[0,1] $slurm_sched_log_level = 0,
  Optional[String] $slurm_sched_log_file = undef,

  Optional[String] $health_check_program = undef,
  Enum['ALLOC','ANY','CYCLE','IDLE','MIXED'] $health_check_node_state = 'ANY',
  Integer[0] $health_check_interval = 0,

  Optional[String] $suspend_program = undef,
  Integer[0] $suspend_timeout = 30,
  Integer[0] $suspend_rate = 60,
  Integer[-1] $suspend_time = -1,
  Optional[String] $suspend_exc_nodes = undef,
  Optional[String] $suspend_exc_parts = undef,
  Optional[String] $resume_program = undef,
  Integer[0] $resume_timeout = 60,
  Integer[0] $resume_rate = 300,

  Enum['topology/3d_torus','topology/node_rank','topology/none','topology/tree'] $topology_plugin= 'topology/none',
  Array[Enum['Dragonfly','NoCtldInAddrAny','NoInAddrAny','TopoOptional']] $topology_param = ['NoCtldInAddrAny','NoInAddrAny'],
  Enum['route/default','route/topology'] $route_plugin = 'route/default',
  Integer[1] $tree_width = 50,

  Array[Hash,1] $workernodes,
  Array[Hash,1] $partitions,

  Boolean $open_firewall = false,
)
```
The configuration class, common to all types of nodes, is responsible to create the main slurm.conf configuration file. For more details about each parameter, please refer to the [SLURM documentation](https://slurm.schedmd.com/slurm.conf.html). Almost all default values are taken from SLURM's official documentation, except the control_machine, the workernodes and the partitions; they are provided as an example.


#### slurm::config::acct_gather
```ruby
class slurm::config::acct_gather (
  Boolean $with_energy_ipmi = false,
  Integer[0] $energy_ipmi_frequency = 10,
  Enum['no','yes'] $energy_ipmi_calc_adjustment = 'no',
  Optional[Hash[String,String]] $energy_ipmi_power_sensors = undef,
  Optional[String] $energy_ipmi_username = undef,
  Optional[String] $energy_ipmi_password = undef,
  Boolean $with_profile_hdf5 = false,
  Optional[String] $profile_hdf5_dir = undef,
  String $profile_hdf5_default = 'None',
  Boolean $with_infiniband_ofed = false,
  Integer[0] $infiniband_ofed_port = 1,
)
```
The acct_gather class is responsible to create the configuration file used by the AcctGather type plugins, namely EnergyIPMI, ProfileHDF5 and InfinibandOFED. Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/acct_gather.conf.html) in the SLURM documentation.


#### slurm::config::cgroup
```ruby
class slurm::config::cgroup (
  Enum['no','yes'] $cgroup_automount = 'no',
  String $cgroup_mountpoint = '/sys/fs/cgroup',
  Enum['no','yes'] $constrain_cores = 'no',
  Enum['no','yes'] $task_affinity = 'no',
  Enum['no','yes'] $constrain_ram_space = 'no',
  Float[0,100] $allowed_ram_space = 100.0,
  Integer[0] $min_ram_space = 30,
  Float[0,100] $max_ram_percent = 100.0,
  Enum['no','yes'] $constrain_swap_space = 'no',
  Float[0,100] $allowed_swap_space = 0.0,
  Float[0,100] $max_swap_percent = 100.0,
  Enum['no','yes'] $constrain_kmem_space = 'yes',
  Float[0,100] $allowed_kmem_space = 1.0,
  Integer[0] $min_kmem_space = 30,
  Float[0,100] $max_kmem_percent = 100.0,
  Enum['no','yes'] $constrain_devices = 'no',
  String $allowed_devices_file = '/etc/slurm/cgroup_allowed_devices_file.conf',
)
```
The cgroup class is responsible to create the configuration file used by all the plugins using cgroups, namely proctrack/cgroup, task/cgroup and jobacct_gather/cgroup. Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/cgroup.conf.html) in the SLURM documentation.

#### slurm::config::topology
```ruby
class slurm::config::topology (
  Array[Hash[String, String]] $switches,
)
```
The topology class is responsible to create the configuration file used by all the plugins using topology, namely topology/tree and route/topology. Details about the parameters can be found on the [dedicated page](https://slurm.schedmd.com/topology.conf.html) in the SLURM documentation.

### slurm::dbnode
```ruby
class slurm::dbnode ()
```
The database class is responsible to call the database specific setup and configure class.

#### slurm::dbnode::setup
```ruby
class slurm::dbnode::setup (
  Array[String] $packages = [
    'slurm-slurmdbd',
    'slurm-sql',
  ],
)
```
The database setup class is responsible to install the necessary packages and create all the necessary folders and files for the dbnode to work.

#### slurm::dbnode::config
```ruby
class slurm::dbnode::config (
  String $file_name = 'slurmdbd.conf',
  String $dbd_host = 'localhost',
  String $dbd_addr = $dbd_host,
  Optional[String] $dbd_backup_host = undef,
  Integer[0] $dbd_port = $slurm::config::accounting_storage_port,
  Enum['auth/none','auth/munge'] $auth_type = 'auth/none',
  Optional[String] $auth_info = undef,
  Optional[String] $default_qos = undef,
  Integer[0] $message_timeout = 10,
  String $pid_file = '/var/run/slurmdbd.pid',
  String $plugin_dir = '/usr/local/lib/slurm' ,
  Optional[String] $private_data = undef,
  String $slurm_user = $slurm::config::slurm_user,
  Integer[0] $tcp_timeout = 2,
  Enum['no','yes'] $track_wc_key = 'no',
  Enum['no','yes'] $track_slurmctld_down = 'no',
  Enum['accounting_storage/mysql'] $storage_type = 'accounting_storage/mysql',
  String $storage_host = 'db_instance.example.org',
  Optional[String] $storage_backup_host = undef,
  Integer[0] $storage_port = 1234,
  String $storage_user = 'user',
  String $storage_pass = 'CHANGEME__storage_pass',
  String $storage_loc = 'accountingdb',
  String $archive_dir = '/tmp',
  Optional[String] $archive_script = undef,
  Enum['no','yes'] $archive_events = 'no',
  Optional[String] $purge_event_after = undef,
  Enum['no','yes'] $archive_jobs = 'no',
  Optional[String] $purge_job_after = undef,
  Enum['no','yes'] $archive_resvs = 'no',
  Optional[String] $purge_resv_after = undef,
  Enum['no','yes'] $archive_steps = 'no',
  Optional[String] $purge_step_after = undef,
  Enum['no','yes'] $archive_suspend = 'no',
  Optional[String] $purge_suspend_after = undef,
  Enum['no','yes'] $archive_txn = 'no',
  Optional[String] $purge_txnafter = undef,
  Enum['no','yes'] $archive_usage = 'no',
  Optional[String] $purge_usage_after = undef,
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $debug_level = 'info',
  Optional[Array[Enum['DB_ARCHIVE','DB_ASSOC','DB_EVENT','DB_JOB','DB_QOS','DB_QUERY','DB_RESERVATION','DB_RESOURCE','DB_STEP','DB_USAGE','DB_WCKEY']]] $debug_flags = undef,
  Optional[String] $log_file = undef,
  Enum['iso8601','iso8601_ms','rfc5424','rfc5424_ms','clock','short'] $log_time_format = 'iso8601_ms',
)
```
The database configuration class is responsible to create the configuration file for the dbnode and start the slurmdbd daemon.

### slurm::headnode
```ruby
class slurm::headnode ()
```
The headnode class is responsible to call the headnode specific setup and configure class.


#### slurm::headnode::setup
```ruby
class slurm::headnode::setup (
  String $state_save_location = $slurm::config::state_save_location,
  String $slurmctld_log_file = $slurm::config::slurmctld_log_file,
  Array[String] $packages = [
    'slurm-perlapi',
    'slurm-torque',
  ],
)
```
The headnode setup class is responsible to install the necessary packages and create all the necessary folders and files for the headnode to work.


#### slurm::headnode::config
```ruby
class slurm::headnode::config ()
```
The headnode configuration class is responsible to start the slurmctld daemon.


### slurm::workernode
```ruby
class slurm::workernode ()
```
The workernode class is responsible to call the workernode specific setup and configure class.


#### slurm::workernode::setup
```ruby
class slurm::workernode::setup (
  String $slurmd_spool_dir = $slurm::config::slurmd_spool_dir,
  String $slurmd_log_file = $slurm::config::slurmd_log_file,
  Array[String] $packages = [
    'slurm-perlapi',
    'slurm-torque',
  ],
)
```
The workernode setup class is responsible to install the necessary packages and create all the necessary folders and files for the workernode to work.


#### slurm::workernode::config
```ruby
class slurm::workernode::config ()
```
The workernode configuration class is responsible to start the slurmd daemon.



### Files

#### acct_gather.conf.erb
Slurm configuration file for the acct_gather plugins. More details in the [acct_gather.conf documentation](https://slurm.schedmd.com/acct_gather.conf.html).

#### cgroup.conf.erb
Slurm configuration file for the cgroup support. More details in the [cgroup.conf documentation](https://slurm.schedmd.com/cgroup.conf.html).

#### plugstack.conf.erb
Slurm configuration file for SPANK plugins. More details in the [SPANK documentation](https://slurm.schedmd.com/spank.html).

#### slurm.conf.erb
Slurm configuration file, common to all the nodes in the cluster. More details in the [slurm.conf documentation](https://slurm.schedmd.com/slurm.conf.html).

#### slurmdbd.conf.erb
Slurm Database Daemon (SlurmDBD) configuration file. More details in the [slurmdbd.conf documentation](https://slurm.schedmd.com/slurmdbd.conf.html).

#### topology.conf.erb
Slurm configuration file for defining the network topology. More details in the [topology.conf documentation](https://slurm.schedmd.com/topology.conf.html).

# Limitations

It has been tested and works on Centos 7.3 with Puppet 4.9.4.


# Development

The future task which needs to be done is testing any new versions of SLURM and checking if the current module still supports the latest features.

As always, changes should be done in a new branch first for testing and then a merged to qa using a merge request. Once the module is validated in qa for at least one week, the changes can be merged into master.

Please document all changes in the CHANGELOG and update this README if necessary!

# Contributors

  * Philippe Ganz (CERN) as creator and main maintainer
  * Carolina Lindqvist (CERN) as creator and main maintainer
  * Pablo Llopis (CERN) as main maintainer
