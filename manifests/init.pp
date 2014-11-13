# == Class: slurm
#
class slurm (
  # Roles
  $node       = true,
  $controller = false,
  $slurmdbd   = false,
  $client     = false,

  # Packages
  $package_require        = undef,
  $version                = 'present',
  $install_torque_wrapper = true,
  $install_lua            = false,
  $install_blcr           = false,
  $install_pam            = false,

  # Services
  $slurm_service_ensure     = 'running',
  $slurm_service_enable     = true,
  $slurmdbd_service_ensure  = 'running',
  $slurmdbd_service_enable  = true,

  # User/group management - controller/slurmdbd
  $manage_slurm_user  = true,
  $slurm_user_group   = 'slurm',
  $slurm_group_gid    = undef,
  $slurm_user         = 'slurm',
  $slurm_user_uid     = undef,
  $slurm_user_comment = 'SLURM User',
  $slurm_user_home    = '/home/slurm',
  $slurm_user_shell   = '/bin/false',
  $slurmd_user        = 'root',
  $slurmd_user_group  = 'root',

  # External modules
  $include_blcr = false,

  # Behavior overrides
  $manage_slurm_conf  = true,
  $manage_scripts     = true,
  $manage_firewall    = true,
  $manage_logrotate   = true,

  # Behavior overrides - controller
  $manage_state_dir_nfs_mount           = false,
  $manage_job_checkpoint_dir_nfs_mount  = false,

  # Behavior overrides - slurmdbd
  $manage_database      = true,
  $use_remote_database  = false,

  # Config - controller
  $state_dir_nfs_device           = undef,
  $state_dir_nfs_options          = 'rw,sync,noexec,nolock,auto',
  $job_checkpoint_dir_nfs_device  = undef,
  $job_checkpoint_dir_nfs_options = 'rw,sync,noexec,nolock,auto',

  # Cluster config
  $cluster_name       = 'linux',
  $control_machine    = 'slurm',

  # Managed directories
  $conf_dir               = '/etc/slurm',
  $log_dir                = '/var/log/slurm',
  $pid_dir                = '/var/run/slurm',
  $shared_state_dir       = '/var/lib/slurm',

  # slurm.conf - overrides
  $slurm_conf_override    = $slurm::params::slurm_conf_override,
  $partitionlist          = $slurm::params::partitionlist,
  $slurm_conf_template    = 'slurm/slurm.conf/slurm.conf.erb',
  $partitionlist_template = 'slurm/slurm.conf/slurm-partitions.conf.erb',
  $node_template          = 'slurm/slurm.conf/node.conf.erb',
  $slurm_nodelist_tag     = 'slurm_nodelist',

  # slurm.conf - node
  $node_name        = $::hostname,
  $node_addr        = $::ipaddress,
  $cpus             = $::processorcount,
  $sockets          = 'UNSET',
  $cores_per_socket = 'UNSET',
  $threads_per_core = 'UNSET',
  $real_memory      = $::real_memory,
  $tmp_disk         = '16000',
  $feature          = 'UNSET',
  $state            = 'UNKNOWN',
  $slurmd_log_file  = '/var/log/slurm/slurmd.log',
  $slurmd_spool_dir = '/var/spool/slurmd',

  # slurm.conf - controller
  $job_checkpoint_dir     = '/var/lib/slurm/checkpoint',
  $slurmctld_log_file     = '/var/log/slurm/slurmctld.log',
  $state_save_location    = '/var/lib/slurm/state',

  # slurmdbd.conf
  $slurmdbd_log_file      = '/var/log/slurm/slurmdbd.log',
  $slurmdbd_storage_host  = 'localhost',
  $slurmdbd_storage_loc   = 'slurmdbd',
  $slurmdbd_storage_pass  = 'slurmdbd',
  $slurmdbd_storage_port  = '3306',
  $slurmdbd_storage_type  = 'accounting_storage/mysql',
  $slurmdbd_storage_user  = 'slurmdbd',
  $slurmdbd_conf_override = $slurm::params::slurmdbd_conf_override,

  # slurm.conf - epilog/prolog
  $epilog                       = undef,
  $epilog_source                = undef,
  $health_check_program         = undef,
  $health_check_program_source  = undef,
  $prolog                       = undef,
  $prolog_source                = undef,
  $task_epilog                  = undef,
  $task_epilog_source           = undef,
  $task_prolog                  = undef,
  $task_prolog_source           = undef,

  # cgroups
  $cgroup_conf_template             = 'slurm/cgroup/cgroup.conf.erb',
  $cgroup_mountpoint                = '/cgroup',
  $cgroup_automount                 = true,
  $cgroup_release_agent_dir         = undef,
  $cgroup_constrain_cores           = false,
  $cgroup_task_affinity             = false,
  $cgroup_allowed_ram_space         = '100',
  $cgroup_allowed_swap_space        = '0',
  $cgroup_constrain_ram_space       = false,
  $cgroup_constrain_swap_space      = false,
  $cgroup_max_ram_percent           = '100',
  $cgroup_max_swap_percent          = '100',
  $cgroup_min_ram_space             = '30',
  $cgroup_constrain_devices         = false,
  $cgroup_allowed_devices           = $slurm::params::cgroup_allowed_devices,
  $cgroup_allowed_devices_template  = 'slurm/cgroup/cgroup_allowed_devices_file.conf.erb',
  $cgroup_allowed_devices_file      = undef,
  $manage_cgroup_release_agents     = true,
  $cgroup_release_common_source     = undef,

  # profile.d
  $slurm_sh_template  = 'slurm/profile.d/slurm.sh.erb',
  $slurm_csh_template = 'slurm/profile.d/slurm.csh.erb',

  # ports
  $slurmd_port    = '6818',
  $slurmctld_port = '6817',
  $slurmdbd_port  = '6819',
) inherits slurm::params {

  # Parameter validations
  validate_bool($node, $controller, $slurmdbd, $client)
  validate_bool($manage_slurm_user, $manage_slurm_conf, $manage_scripts, $manage_firewall, $manage_logrotate)
  validate_bool($install_pam, $install_torque_wrapper, $install_lua, $install_blcr)
  validate_bool($manage_state_dir_nfs_mount, $manage_job_checkpoint_dir_nfs_mount)
  validate_bool($manage_database, $use_remote_database)
  validate_bool($cgroup_automount, $cgroup_constrain_cores, $cgroup_task_affinity, $cgroup_constrain_ram_space)
  validate_bool($cgroup_constrain_swap_space, $cgroup_constrain_devices, $manage_cgroup_release_agents)

  validate_array($partitionlist, $cgroup_allowed_devices)

  validate_hash($slurm_conf_override, $slurmdbd_conf_override)

  if $node and $controller {
    fail("Module ${module_name}: Does not support both node and controller being enabled on the same host.")
  }

  if $node and $slurmdbd {
    fail("Module ${module_name}: Does not support both node and slurmdbd being enabled on the same host.")
  }

  if $node and $client {
    fail("Module ${module_name}: Does not support both node and client being enabled on the same host.")
  }

  if $controller and $client {
    fail("Module ${module_name}: Does not support both controller and client being enabled on the same host.")
  }

  if $slurmdbd and $client {
    fail("Module ${module_name}: Does not support both slurmdbd and client being enabled on the same host.")
  }

  $slurm_conf_path                    = "${conf_dir}/slurm.conf"
  $node_conf_path                     = "${conf_dir}/nodes.conf"
  $partition_conf_path                = "${conf_dir}/partitions.conf"
  $slurmdbd_conf_path                 = "${conf_dir}/slurmdbd.conf"
  $cgroup_release_agent_dir_real      = pick($cgroup_release_agent_dir, "${conf_dir}/cgroup")
  $cgroup_allowed_devices_file_real   = pick($cgroup_allowed_devices_file, "${conf_dir}/cgroup_allowed_devices_file.conf")
  $cgroup_release_common_source_real  = pick($cgroup_release_common_source, "file://${conf_dir}/cgroup.release_common.example")

  $slurm_conf_local_defaults = {
    'AccountingStorageHost' => $control_machine,
    'AccountingStoragePort' => $slurmdbd_port,
    'ClusterName' => $cluster_name,
    'ControlMachine' => $control_machine,
    'DefaultStorageHost' => $control_machine,
    'DefaultStoragePort' => $slurmdbd_port,
    'Epilog' => $epilog,
    'HealthCheckProgram' => $health_check_program,
    'JobCheckpointDir' => $job_checkpoint_dir,
    'PlugStackConfig' => "${conf_dir}/plugstack.conf",
    'Prolog' => $prolog,
    'SlurmUser' => $slurm_user,
    'SlurmctldLogFile' => $slurmctld_log_file,
    'SlurmctldPidFile' => "${pid_dir}/slurmctld.pid",
    'SlurmctldPort' => $slurmctld_port,
    'SlurmdLogFile' => $slurmd_log_file,
    'SlurmdPidFile' => "${pid_dir}/slurmd.pid",
    'SlurmdPort' => $slurmd_port,
    'SlurmdSpoolDir' => $slurmd_spool_dir,
    'SlurmSchedLogFile' => "${log_dir}/slurmsched.log",
    'SlurmdUser' => $slurmd_user,
    'StateSaveLocation' => $state_save_location,
    'TaskEpilog' => $task_epilog,
    'TaskProlog' => $task_prolog,
  }

  $slurm_conf_defaults  = merge($slurm::params::slurm_conf_defaults, $slurm_conf_local_defaults)
  $slurm_conf           = merge($slurm_conf_defaults, $slurm_conf_override)

  $slurmdbd_conf_local_defaults = {
    'DbdHost' => $::hostname,
    'DbdPort' => $slurmdbd_port,
    'LogFile' => $slurmdbd_log_file,
    'PidFile' => "${pid_dir}/slurmdbd.pid",
    'SlurmUser' => $slurm_user,
    'StorageHost' => $slurmdbd_storage_host,
    'StorageLoc' => $slurmdbd_storage_loc,
    'StoragePass' => $slurmdbd_storage_pass,
    'StoragePort' => $slurmdbd_storage_port,
    'StorageType' => $slurmdbd_storage_type,
    'StorageUser' => $slurmdbd_storage_user,
  }

  $slurmdbd_conf_defaults = merge($slurm::params::slurmdbd_conf_defaults, $slurmdbd_conf_local_defaults)
  $slurmdbd_conf          = merge($slurmdbd_conf_defaults, $slurmdbd_conf_override)

  anchor { 'slurm::start': }
  anchor { 'slurm::end': }

  if $node {
    include slurm::node

    Anchor['slurm::start']->
    Class['slurm::node']->
    Anchor['slurm::end']
  }

  if $controller {
    include slurm::controller

    Anchor['slurm::start']->
    Class['slurm::controller']->
    Anchor['slurm::end']
  }

  if $slurmdbd {
    include slurm::slurmdbd

    Anchor['slurm::start']->
    Class['slurm::slurmdbd']->
    Anchor['slurm::end']
  }

  if $client {
    include slurm::client

    Anchor['slurm::start']->
    Class['slurm::client']->
    Anchor['slurm::end']
  }

}
