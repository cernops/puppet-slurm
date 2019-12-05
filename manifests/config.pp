# slurm/config.pp
#
# Creates the common configuration files.
#
# For details about the parameters, please refer to the SLURM documentation at https://slurm.schedmd.com/slurm.conf.html
#
# version 20170829
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

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
  Optional[String] $reboot_program = undef,
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
  Optional[Array[Enum['Alloc','Contain','NoHold', 'Serial', 'X11']]] $prolog_flags = undef,
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
  Enum['acct_gather_interconnect/none','acct_gather_interconnect/ofed','acct_gather_infiniband/ofed'] $acct_gather_interconnect_type = 'acct_gather_interconnect/none',
  Enum['acct_gather_filesystem/none','acct_gather_filesystem/lustre'] $acct_gather_filesystem_type = 'acct_gather_filesystem/none',
  Enum['acct_gather_profile/none','acct_gather_profile/hdf5'] $acct_gather_profile_type = 'acct_gather_profile/none',

  Optional[Array[String]] $debug_flags = undef,
  Enum['iso8601','iso8601_ms','rfc5424','rfc5424_ms','clock','short'] $log_time_format = 'iso8601_ms',
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $slurmctld_debug = 'info',
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $slurmctld_syslog_debug = 'info',
  Optional[String] $slurmctld_log_file = undef,
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $slurmd_debug = 'info',
  Enum['quiet','fatal','error','info','verbose','debug','debug2','debug3','debug4','debug5'] $slurmd_syslog_debug = 'info',
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
  Array[String] $munge_packages = $slurm::params::munge_packages,
  Boolean $shared_config = false,
  Optional[String] $shared_config_path = undef,
) inherits slurm::params {

  # The following variables are version dependent
  if $slurmctld_syslog_debug != undef or $slurmd_syslog_debug != undef {
    if versioncmp('17.11', $slurm::params::slurm_version) > 0 {
      fail('Parameters SlurmctldSyslogDebug,SlurmdSyslogDebug are supported from version 17.11 onwards.')
    }
  }

  # Authentication service for SLURM if MUNGE is used as authentication plugin
  if  ($auth_type == 'auth/munge') or
      ($crypto_type == 'crypto/munge') {

    ensure_packages($munge_packages, {'ensure' => $munge_version})

    group{ 'munge':
      ensure => present,
      gid    => $munge_gid,
      system => true,
    }
    user{ 'munge':
      ensure  => present,
      comment => 'Munge',
      home    => '/var/lib/munge',
      gid     => $munge_gid,
      require => Group['munge'],
      system  => true,
      uid     => $munge_uid,
    }
    file{ dirtree($munge_loc, $munge_loc) :
      ensure  => directory,
    }
    -> file{ 'munge folder':
      ensure  => directory,
      path    => $munge_loc,
      owner   => 'munge',
      group   => 'munge',
      mode    => '1700',
      require => User['munge'],
    }
    file{ dirtree($munge_home_loc, $munge_home_loc) :
      ensure  => directory,
    }
    -> file{ 'munge homedir':
      ensure  => directory,
      path    => $munge_home_loc,
      owner   => 'munge',
      group   => 'munge',
      mode    => '1700',
      require => User['munge'],
    }
    file{ dirtree($munge_log_file, $munge_log_file) :
      ensure  => directory,
    }
    -> file{ 'munge log folder':
      ensure  => directory,
      path    => $munge_log_file,
      owner   => 'munge',
      group   => 'munge',
      mode    => '1700',
      require => User['munge'],
    }
    file{ dirtree($munge_run_loc, $munge_run_loc) :
      ensure  => directory,
    }
    -> file{ 'munge run folder':
      ensure  => directory,
      path    => $munge_run_loc,
      owner   => 'munge',
      group   => 'munge',
      mode    => '1755',
      require => User['munge'],
    }

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

  if $cluster_name != undef {
    $shared_config_filepath = "${shared_config_path}/${cluster_name}.conf"
  } else {
    $shared_config_filepath = "${shared_config_path}/slurm.conf"
  }

  if $shared_config {
    # slurm.conf just includes another file. That file's path is either:
    # $shared_config_path/slurm.conf if $slurm::cluster_name is undefined,
    # $shared_config_path/$cluster_name.conf otherwise.
    if $shared_config_path == undef {
      fail('shared_config_path needs to be defined when $shared_config=True')
    }
    file { '/etc/slurm/slurm.conf':
      ensure  => file,
      content => template('slurm/slurm-shared.conf.erb'),
      owner   => 'slurm',
      group   => 'slurm',
      mode    => '0644',
      require => User['slurm'],
    }
  } else {
    # Create slurm.conf with full configuration
    file{'/etc/slurm/slurm.conf':
      ensure  => file,
      content => template('slurm/slurm.conf.erb'),
      owner   => 'slurm',
      group   => 'slurm',
      mode    => '0644',
      require => User['slurm'],
    }
  }

  if $shared_config and $slurm::node_type == 'head' {
    file { $shared_config_filepath:
      ensure  => file,
      content => template('slurm/slurm.conf.erb'),
      owner   => 'slurm',
      group   => 'slurm',
      mode    => '0644',
      require => User['slurm'],
    }
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
      (['acct_gather_infiniband/ofed', 'acct_gather_interconnect/ofed'] in $acct_gather_interconnect_type) {
    class{ '::slurm::config::acct_gather':
      with_energy_ipmi       => ('acct_gather_energy/ipmi' in $acct_gather_energy_type),
      with_profile_hdf5      => ('acct_gather_profile/hdf5' in $acct_gather_profile_type),
      with_interconnect_ofed => (['acct_gather_infiniband/ofed', 'acct_gather_interconnect/ofed'] in $acct_gather_interconnect_type),
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
