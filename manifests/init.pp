# == Class: slurm
#
class slurm (
  # Role booleans
  $worker = true,
  $master = false,
  $slurmdbd = false,

  # Package ensures
  $munge_package_ensure = 'present',
  $slurm_package_ensure = 'present',
  $auks_package_ensure = 'present',
  $package_runtime_dependencies = $slurm::params::package_runtime_dependencies,

  # User/group management - master
  $manage_slurm_user = true,
  $slurm_user_group = 'slurm',
  $slurm_group_gid = 'UNSET',
  $slurm_user = 'slurm',
  $slurm_user_uid = 'UNSET',
  $slurm_user_comment = 'SLURM User',
  $slurm_user_home = '/home/slurm',
  $slurm_user_shell = '/bin/false',

  # Cluster config
  $cluster_name = 'linux',
  $control_machine = 'slurm',

  # Master config
  $manage_state_dir_nfs_mount = true,
  $state_dir_nfs_device = undef,
  $state_dir_nfs_options = 'rw,sync,noexec,nolock,auto',

  # Worker config
  $tmp_disk = '16000',

  # Partitions
  $partitionlist = [],
  $partitionlist_template = 'slurm/slurm.conf/master/slurm.conf.partitions.erb',

  # Managed directories
  $log_dir = '/var/log/slurm',
  $pid_dir = '/var/run/slurm',
  $spool_dir = '/var/spool/slurm',
  $shared_state_dir = '/var/lib/slurm',

  # slurm.conf - master
  $job_checkpoint_dir = '/var/lib/slurm/checkpoint',
  $slurmctld_log_file = '/var/log/slurm/slurmctld.log',
  $state_save_location = '/var/lib/slurm/state',

  # slurm.conf - worker
  $slurmd_log_file = '/var/log/slurm/slurmd.log',
  $slurmd_user = 'root',
  $slurmd_user_group = 'root',
  $slurmd_spool_dir = '/var/spool/slurm/slurmd',

  # slurm.conf - epilog/prolog
  $epilog = undef,
  $epilog_source = undef,
  $health_check_program = undef,
  $health_check_program_source = undef,
  $prolog = undef,
  $prolog_source = undef,
  $task_epilog = undef,
  $task_epilog_source = undef,
  $task_prolog = undef,
  $task_prolog_source = undef,

  # slurm.conf - overrides
  $slurm_conf_override = {},
  $slurm_conf_template = 'slurm/slurm.conf/common/slurm.conf.options.erb',
  $slurm_conf_source = undef,

  # slurmdbd.conf
  $slurmdbd_log_file = '/var/log/slurm/slurmdbd.log',
  $storage_host = 'localhost',
  $storage_loc = 'slurmdbd',
  $storage_pass = 'slurmdbd',
  $storage_port = '3306',
  $storage_type = 'accounting_storage/mysql',
  $storage_user = 'slurmdbd',

  # slurmdbd.conf - overrides
  $slurmdbd_conf_override = {},

  # Munge
  $munge_key = undef,

  # auks
  $use_auks = false,

  # pam
  $use_pam = false,

  # Firewall / ports
  $manage_firewall = true,
  $slurmd_port = '6818',
  $slurmctld_port = '6817',
  $slurmdbd_port = '6819',

  # Logrotate
  $manage_logrotate = true,
) inherits slurm::params {

  # Parameter validations
  validate_bool($worker)
  validate_bool($master)
  validate_bool($slurmdbd)
  validate_bool($manage_slurm_user)
  validate_bool($manage_state_dir_nfs_mount)
  validate_array($partitionlist)
  validate_hash($slurm_conf_override)
  validate_hash($slurmdbd_conf_override)
  validate_bool($use_auks)
  validate_bool($use_pam)
  validate_bool($manage_firewall)
  validate_bool($manage_logrotate)

  $slurm_conf_defaults = {
    'AccountingStorageHost' => $control_machine,
    'AccountingStoragePort' => $slurmdbd_port,
    'AccountingStorageType' => 'accounting_storage/slurmdbd',
    'AccountingStoreJobComment' => 'YES',
    'AuthType' => 'auth/munge',
    'CacheGroups' => '0',
    'CheckpointType' => 'checkpoint/none',
    'ClusterName' => $cluster_name,
    'CompleteWait' => '0',
    'ControlMachine' => $control_machine,
    'CryptoType' => 'crypto/munge',
    'DefaultStorageHost' => $control_machine,
    'DefaultStoragePort' => $slurmdbd_port,
    'DefaultStorageType' => 'slurmdbd',
    'DisableRootJobs' => 'NO',
    'Epilog' => $epilog,
    'EpilogMsgTime' => '2000',
    'FastSchedule' => '1',
    'FirstJobId' => '1',
    'GetEnvTimeout' => '2',
    'GroupUpdateForce' => '0',
    'GroupUpdateTime' => '600',
    'HealthCheckInterval' => '0',
    'HealthCheckNodeState' => 'ANY',
    'HealthCheckProgram' => $health_check_program,
    'InactiveLimit' => '0',
    'JobAcctGatherFrequency' => '30',
    'JobAcctGatherType' => 'jobacct_gather/linux',
    'JobCheckpointDir' => $job_checkpoint_dir,
    'JobCompType' => 'jobcomp/none',
    'JobRequeue' => '1',
    'KillOnBadExit' => '0',
    'KillWait' => '30',
    'MailProg' => '/bin/mail',
    'MaxJobCount' => '10000',
    'MaxJobId' => '4294901760',
    'MaxMemPerCPU' => '0',
    'MaxMemPerNode' => '0',
    'MaxStepCount' => '40000',
    'MaxTasksPerNode' => '128',
    'MessageTimeout' => '10',
    'MinJobAge' => '300',
    'MpiDefault' => 'none',
    'OverTimeLimit' => '0',
    'PluginDir' => '/usr/lib64/slurm',
    'PreemptMode' => 'OFF',
    'PreemptType' => 'preempt/none',
    'PriorityType' => 'priority/basic',
    'ProctrackType' => 'proctrack/pgid',
    'Prolog' => $prolog,
    'PropagatePrioProcess' => '0',
    'PropagateResourceLimits' => 'ALL',
    'ResvOverRun' => '0',
    'ReturnToService' => '0',
    'SchedulerTimeSlice' => '30',
    'SchedulerType' => 'sched/builtin',
    'SelectType' => 'select/linear',
    'SlurmUser' => $slurm_user,
    'SlurmctldDebug' => '3',
    'SlurmctldLogFile' => $slurmctld_log_file,
    'SlurmctldPidFile' => "${pid_dir}/slurmctld.pid",
    'SlurmctldPort' => $slurmctld_port,
    'SlurmctldTimeout' => '300',
    'SlurmdDebug' => '3',
    'SlurmdLogFile' => $slurmd_log_file,
    'SlurmdPidFile' => "${pid_dir}/slurmd.pid",
    'SlurmdPort' => $slurmd_port,
    'SlurmdSpoolDir' => $slurmd_spool_dir,
    'SlurmdTimeout' => '300',
    'SlurmSchedLogFile' => "${log_dir}/slurmsched.log",
    'SlurmSchedLogLevel' => '0',
    'SlurmdUser' => $slurmd_user,
    'StateSaveLocation' => $state_save_location,
    'SwitchType' => 'switch/none',
    'TaskEpilog' => $task_epilog,
    'TaskPlugin' => 'task/none',
    'TaskProlog' => $task_prolog,
    'TmpFS' => '/tmp',
    'TopologyPlugin'  => 'topology/none',
    'TrackWCKey' => 'no',
    'TreeWidth' => '50',
    'UsePAM' => bool2num($use_pam),
    'VSizeFactor' => '0',
    'WaitTime' => '0',
  }

  $slurmdbd_conf_defaults = {
    'ArchiveDir' => '/tmp',
    'ArchiveEvents' => 'no',
    'ArchiveJobs' => 'no',
    'ArchiveSteps' => 'no',
    'ArchiveSuspend' => 'no',
    'AuthType' => 'auth/munge',
    'DbdHost' => $::hostname,
    'DbdPort' => $slurmdbd_port,
    'DebugLevel' => '3',
    'LogFile' => $slurmdbd_log_file,
    'MessageTimeout' => '10',
    'PidFile' => "${pid_dir}/slurmdbd.pid",
    'PluginDir' => '/usr/lib64/slurm',
    'SlurmUser' => $slurm_user,
    'StorageHost' => $storage_host,
    'StorageLoc' => $storage_loc,
    'StoragePass' => $storage_pass,
    'StoragePort' => $storage_port,
    'StorageType' => $storage_type,
    'StorageUser' => $storage_user,
    'TrackSlurmctldDown' => 'no',
  }

  $gid = $slurm::slurm_group_gid ? {
    'UNSET' => undef,
    default => $slurm_group_gid,
  }

  $uid = $slurm::slurm_user_uid ? {
    'UNSET' => undef,
    default => $slurm_user_uid,
  }

  $slurm_conf = merge($slurm_conf_defaults, $slurm_conf_override)
  $slurmdbd_conf = merge($slurmdbd_conf_defaults, $slurmdbd_conf_override)

  if $worker {
    class { 'slurm::worker': }
  }

  if $master {
    class { 'slurm::master': }
  }

  if $slurmdbd {
    class { 'slurm::slurmdbd': }
  }

}
