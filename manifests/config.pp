# slurm/config.pp
#
# Creates the common configuration files.
#
# For details about the parameters, please refer to the SLURM documentation at https://slurm.schedmd.com/slurm.conf.html
#
# version 20170802
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

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
  String[1,default] $state_save_location = '/var/spool/slurmctld',
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

  Boolean $open_firewall = false,
) {

  # Authentication service for SLURM if MUNGE is used as authentication plugin
  if  ($auth_type == 'auth/munge') or
      ($crypto_type == 'crypto/munge') {
    service{'munge':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      subscribe => File['munge homedir','/etc/munge/munge.key'],
    }
  }

  # If openssl will be used for the crypto plugin, the key pair is a required file
  if $crypto_type == 'crypto/openssl' {
    $openssl_credential_files = [$job_credential_private_key,$job_credential_public_certificate]
  }
  else {
    $openssl_credential_files = []
  }

  # Common SLURM configuration file
  file{'/etc/slurm/slurm.conf':
    ensure  => file,
    content => template('slurm/slurm.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

  # Plugin loader
  file{ '/etc/slurm/plugstack.conf':
    ensure  => file,
    content => template('slurm/plugstack.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }

  # Accounting gatherer configuration file
  if  ('acct_gather_energy/ipmi' in $acct_gather_energy_type) or
      ('acct_gather_profile/hdf5' in $acct_gather_profile_type) or
      ('acct_gather_infiniband/ofed' in $acct_gather_infiniband_type) {
    class{ '::slurm::config::acct_gather':
      with_energy_ipmi     => ('acct_gather_energy/ipmi' in $acct_gather_energy_type),
      with_profile_hdf5    => ('acct_gather_profile/hdf5' in $acct_gather_profile_type),
      with_infiniband_ofed => ('acct_gather_infiniband/ofed' in $acct_gather_infiniband_type),
    }

    $acct_gather_conf_file = ['/etc/slurm/acct_gather.conf']
  }
  else {
    $acct_gather_conf_file = []
  }

  # Cgroup configuration file
  if  ('proctrack/cgroup' in $proctrack_type) or
      ('task/cgroup' in $task_plugin) or
      ('jobacct_gather/cgroup' in $job_acct_gather_type) {
    class{ '::slurm::config::cgroup':}

    $cgroup_conf_file = ['/etc/slurm/cgroup.conf']
  }
  else {
    $cgroup_conf_file = []
  }

  # Topology plugin configuration file
  if  ('topology/tree' in $topology_plugin) {
    class{ '::slurm::config::topology':}
    $topology_conf_file = ['/etc/slurm/topology.conf']
  }
  else {
    $topology_conf_file = []
  }

  $common_config_files = [
    '/etc/slurm/plugstack.conf',
    '/etc/slurm/slurm.conf',
  ]

  $required_files = concat($openssl_credential_files, $acct_gather_conf_file, $cgroup_conf_file, $topology_conf_file, $common_config_files)

}
