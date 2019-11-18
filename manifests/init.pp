# == Class: slurm
#
class slurm (
  # Roles
  Boolean $slurmd     = false,
  Boolean $slurmctld  = false,
  Boolean $slurmdbd   = false,
  Boolean $database   = false,
  Boolean $client     = true,

  # Repo (optional)
  Optional[Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl, Pattern[/^file:\/\//]]] $repo_baseurl = undef,

  # Packages
  String $version                 = 'present',
  Boolean $install_torque_wrapper = false,
  Boolean $install_pam            = true,

  # Services
  Enum['running','stopped'] $slurmd_service_ensure    = 'running',
  Boolean $slurmd_service_enable                      = true,
  Hash $slurmd_service_limits                         = {},
  String $slurmd_options                              = '',
  Enum['running','stopped'] $slurmctld_service_ensure = 'running',
  Boolean $slurmctld_service_enable                   = true,
  Hash $slurmctld_service_limits                      = {},
  String $slurmctld_options                           = '',
  Enum['running','stopped'] $slurmdbd_service_ensure  = 'running',
  Boolean $slurmdbd_service_enable                    = true,
  Hash $slurmdbd_service_limits                       = {},
  String $slurmdbd_options                            = '',

  # User and group management
  $manage_slurm_user      = true,
  $slurm_user_group       = 'slurm',
  $slurm_group_gid        = undef,
  $slurm_user             = 'slurm',
  $slurm_user_uid         = undef,
  $slurm_user_comment     = 'SLURM User',
  $slurm_user_home        = '/home/slurm',
  $slurm_user_managehome  = true,
  $slurm_user_shell       = '/bin/false',
  $slurmd_user            = 'root',
  $slurmd_user_group      = 'root',

  # Behavior overrides
  $manage_slurm_conf             = true,
  $manage_scripts                = true,
  $manage_firewall               = true,

  # Logging
  $use_syslog                    = false,
  $manage_logrotate              = true,
  $manage_rsyslog                = true,

  # Behavior overrides - controller
  $manage_state_dir_nfs_mount           = false,
  $manage_job_checkpoint_dir_nfs_mount  = false,

  # Behavior overrides - slurmdbd
  $manage_database  = true,
  $export_database  = false,

  # Config - controller
  $state_dir_nfs_device           = undef,
  $state_dir_nfs_options          = 'rw,sync,noexec,nolock,auto',
  $job_checkpoint_dir_nfs_device  = undef,
  $job_checkpoint_dir_nfs_options = 'rw,sync,noexec,nolock,auto',

  # Cluster config
  $cluster_name       = 'linux',
  $slurmctld_host     = 'slurm',
  $slurmdbd_host      = 'slurmdbd',

  # Managed directories
  Stdlib::Absolutepath $conf_dir = '/etc/slurm',
  Stdlib::Absolutepath $log_dir  = '/var/log/slurm',

  # SPANK
  $plugstack_conf         = undef,
  $plugstack_conf_d       = undef,
  $purge_plugstack_conf_d = true,
  $spank_plugins          = {},

  # slurm.conf - overrides
  $slurm_conf_override    = {},
  $slurm_conf_template    = 'slurm/slurm.conf/slurm.conf.erb',
  $slurm_conf_source      = undef,
  $partition_template     = 'slurm/slurm.conf/partition.conf.erb',
  $partition_source       = undef,
  $node_template          = 'slurm/slurm.conf/node.conf.erb',
  $node_source            = undef,
  $switch_template        = 'slurm/switch.conf.erb',
  $topology_source        = undef,
  $gres_template          = 'slurm/gres.conf.erb',
  $gres_source            = undef,
  $partitions             = {},
  $nodes                  = {},
  $switches               = {},
  $greses                 = {},

  # slurm.conf - node
  Optional[Stdlib::Absolutepath] $slurmd_log_file  = undef,
  $slurmd_spool_dir = '/var/spool/slurmd',

  # slurm.conf - controller
  $job_checkpoint_dir     = '/var/spool/slurmctld.checkpoint',
  Optional[Stdlib::Absolutepath] $slurmctld_log_file     = undef,
  $state_save_location    = '/var/spool/slurmctld.state',

  # slurmdbd.conf
  Optional[Stdlib::Absolutepath] $slurmdbd_log_file      = undef,
  $slurmdbd_storage_host  = 'localhost',
  $slurmdbd_storage_loc   = 'slurm_acct_db',
  $slurmdbd_storage_pass  = 'slurmdbd',
  $slurmdbd_storage_port  = '3306',
  $slurmdbd_storage_type  = 'accounting_storage/mysql',
  $slurmdbd_storage_user  = 'slurmdbd',
  $slurmdbd_conf_override = {},

  # slurm.conf health check
  $use_nhc                      = false,
  $include_nhc                  = false,
  $health_check_program         = undef,
  $health_check_program_source  = undef,

  # slurm.conf - epilog/prolog
  $manage_epilog                = true,
  $epilog                       = undef,
  $epilog_source                = undef,
  $manage_prolog                = true,
  $prolog                       = undef,
  $prolog_source                = undef,
  $manage_task_epilog           = true,
  $task_epilog                  = undef,
  $task_epilog_source           = undef,
  $manage_task_prolog           = true,
  $task_prolog                  = undef,
  $task_prolog_source           = undef,

  # cgroups
  String $cgroup_conf_template             = 'slurm/cgroup/cgroup.conf.erb',
  Optional[String] $cgroup_conf_source               = undef,
  Boolean $cgroup_automount                 = true,
  Stdlib::Absolutepath $cgroup_mountpoint                = '/sys/fs/cgroup',
  Optional[Integer] $cgroup_allowed_kmem_space = undef,
  Integer $cgroup_allowed_ram_space         = 100,
  Integer $cgroup_allowed_swap_space        = 0,
  Boolean $cgroup_constrain_cores           = false,
  Boolean $cgroup_constrain_devices         = false,
  Boolean $cgroup_constrain_kmem_space       = false,
  Boolean $cgroup_constrain_ram_space       = false,
  Boolean $cgroup_constrain_swap_space      = false,
  Integer $cgroup_max_ram_percent           = 100,
  Integer $cgroup_max_swap_percent          = 100,
  Integer $cgroup_max_kmem_percent          = 100,
  Optional[Integer[0,100]] $cgroup_memory_swappiness = undef,
  Integer $cgroup_min_kmem_space             = 30,
  Integer $cgroup_min_ram_space             = 30,
  Boolean $cgroup_task_affinity             = false,

  # profile.d
  $slurm_sh_template  = 'slurm/profile.d/slurm.sh.erb',
  $slurm_csh_template = 'slurm/profile.d/slurm.csh.erb',

  # ports
  Stdlib::Port $slurmd_port    = 6818,
  Stdlib::Port $slurmctld_port = 6817,
  Stdlib::Port $slurmdbd_port  = 6819,

  # tuning
  Variant[Boolean, Integer] $tuning_net_core_somaxconn = 1024,
) inherits slurm::params {

  $osfamily = $facts.dig('os', 'family')
  $osmajor = $facts.dig('os', 'release', 'major')
  $os = "${osfamily}-${osmajor}"
  $supported = ['RedHat-7','RedHat-8']
  if ! ($os in $supported) {
    fail("Unsupported OS: ${os}, module ${module_name} only supports RedHat 7 and 8")
  }

  if ! ($slurmd or $slurmctld or $slurmdbd or $database or $client) {
    fail("Module ${module_name}: Must select a mode of either slurmd, slurmctld, slurmdbd database, or client.")
  }

  $slurm_conf_path                    = "${conf_dir}/slurm.conf"
  $node_conf_path                     = "${conf_dir}/nodes.conf"
  $partition_conf_path                = "${conf_dir}/partitions.conf"
  $topology_conf_path                 = "${conf_dir}/topology.conf"
  $gres_conf_path                     = "${conf_dir}/gres.conf"
  $slurmdbd_conf_path                 = "${conf_dir}/slurmdbd.conf"
  $plugstack_conf_path                = pick($plugstack_conf, "${conf_dir}/plugstack.conf")
  $plugstack_conf_d_path              = pick($plugstack_conf_d, "${conf_dir}/plugstack.conf.d")
  $cgroup_conf_path                   = "${conf_dir}/cgroup.conf"

  if $use_syslog {
    $_slurmctld_log_file = 'UNSET'
    $_slurmdbd_log_file = 'UNSET'
    $_slurmd_log_file = 'UNSET'
    $_logrotate_postrotate = '/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true'
  } else {
    $_slurmctld_log_file = pick($slurmctld_log_file, "${log_dir}/slurmctld.log")
    $_slurmdbd_log_file = pick($slurmdbd_log_file, "${log_dir}/slurmdbd.log")
    $_slurmd_log_file = pick($slurmd_log_file, "${log_dir}/slurmd.log")
    $_logrotate_postrotate = [
      'pkill -x --signal SIGUSR2 slurmctld',
      'pkill -x --signal SIGUSR2 slurmd',
      'pkill -x --signal SIGUSR2 slurmdbd',
      'exit 0',
    ]
  }

  if $use_nhc {
    $_health_check_program = pick($health_check_program, '/usr/sbin/nhc')
  } else {
    $_health_check_program = $health_check_program
  }

  $slurm_conf_local_defaults = {
    'AccountingStorageHost' => $slurmdbd_host,
    'AccountingStoragePort' => $slurmdbd_port,
    'ClusterName' => $cluster_name,
    'DefaultStorageHost' => $slurmdbd_host,
    'DefaultStoragePort' => $slurmdbd_port,
    'Epilog' => $epilog,
    'EpilogSlurmctld' => undef, #TODO
    'HealthCheckProgram' => $_health_check_program,
    'JobCheckpointDir' => $job_checkpoint_dir,
    'PlugStackConfig' => $plugstack_conf_path,
    'Prolog' => $prolog,
    'PrologSlurmctld' => undef, #TODO
    'ResvEpilog' => undef, #TODO
    'ResvProlog' => undef, #TODO
    'SlurmUser' => $slurm_user,
    'SlurmctldHost' => [$slurmctld_host],
    'SlurmctldLogFile' => $_slurmctld_log_file,
    'SlurmctldPort' => $slurmctld_port,
    'SlurmdLogFile' => $_slurmd_log_file,
    'SlurmdPort' => $slurmd_port,
    'SlurmdSpoolDir' => $slurmd_spool_dir,
    'SlurmSchedLogFile' => "${log_dir}/slurmsched.log",
    'SlurmdUser' => $slurmd_user,
    'SrunEpilog' => undef, #TODO
    'SrunProlog' => undef, #TODO
    'StateSaveLocation' => $state_save_location,
    'TaskEpilog' => $task_epilog,
    'TaskProlog' => $task_prolog,
    'UsePAM' => $install_pam ? {
      true    => '1',
      default => '0',
    },
  }

  $slurm_conf_defaults  = merge($::slurm::params::slurm_conf_defaults, $slurm_conf_local_defaults)
  $slurm_conf           = merge($slurm_conf_defaults, $slurm_conf_override)

  $slurmdbd_conf_local_defaults = {
    'DbdHost' => $slurmdbd_host,
    'DbdPort' => $slurmdbd_port,
    'LogFile' => $_slurmdbd_log_file,
    'SlurmUser' => $slurm_user,
    'StorageHost' => $slurmdbd_storage_host,
    'StorageLoc' => $slurmdbd_storage_loc,
    'StoragePass' => $slurmdbd_storage_pass,
    'StoragePort' => $slurmdbd_storage_port,
    'StorageType' => $slurmdbd_storage_type,
    'StorageUser' => $slurmdbd_storage_user,
  }

  $slurmdbd_conf_defaults = merge($::slurm::params::slurmdbd_conf_defaults, $slurmdbd_conf_local_defaults)
  $slurmdbd_conf          = merge($slurmdbd_conf_defaults, $slurmdbd_conf_override)

  if $slurm_conf_source {
    $slurm_conf_content = undef
  } else {
    $slurm_conf_content = template($slurm_conf_template)
  }

  if $cgroup_conf_source {
    $cgroup_conf_content = undef
  } else {
    $cgroup_conf_content = template($cgroup_conf_template)
  }

  if $slurmd {
    $slurmd_notify = Service['slurmd']
  } else {
    $slurmd_notify = undef
  }
  if $slurmctld {
    $slurmctld_notify = Service['slurmctld']
  } else {
    $slurmctld_notify = undef
  }
  if $slurmdbd {
    $slurmdbd_notify = Service['slurmdbd']
  } else {
    $slurmdbd_notify = undef
  }
  $service_notify = delete_undef_values([$slurmd_notify, $slurmctld_notify, $slurmdbd_notify])

  if $slurmd {
    contain slurm::slurmd
  }

  if $slurmctld {
    contain slurm::slurmctld
  }

  if $slurmdbd {
    contain slurm::slurmdbd
  }

  if $database {
    contain slurm::slurmdbd::db
  }

  if $client {
    contain slurm::client
  }

}
