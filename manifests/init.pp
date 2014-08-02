# == Class: slurm
#
class slurm (
  # Package ensures
  $package_require = undef,
  $slurm_package_ensure = 'present',
  $auks_package_ensure = 'present',
  $package_runtime_dependencies = $slurm::params::package_runtime_dependencies,

  # User/group management - controller
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

  # Partitions
  $partitionlist = [],
  $partitionlist_template = 'slurm/slurm.conf/slurm.conf.partitions.erb',

  # Managed directories
  $conf_dir = '/home/slurm/conf',
  $log_dir = '/var/log/slurm',
  $pid_dir = '/var/run/slurm',
  $shared_state_dir = '/var/lib/slurm',

  # slurm.conf - controller
  $job_checkpoint_dir = '/var/lib/slurm/checkpoint',
  $slurmctld_log_file = '/var/log/slurm/slurmctld.log',
  $state_save_location = '/var/lib/slurm/state',

  # slurm.conf - node
  $slurmd_log_file = '/var/log/slurm/slurmd.log',
  $slurmd_user = 'root',
  $slurmd_user_group = 'root',
  $slurmd_spool_dir = '/var/spool/slurmd',

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
  $slurm_conf_template = 'slurm/slurm.conf/slurm.conf.options.erb',
  $slurm_conf_source = undef,
  $slurm_nodelist_tag = 'slurm_nodelist',

  # profile.d
  $slurm_sh_template = 'slurm/profile.d/slurm.sh.erb',
  $slurm_csh_template = 'slurm/profile.d/slurm.csh.erb',

  # auks
  $use_auks = false,

  # pam
  $use_pam = false,

  # ports
  $slurmd_port = '6818',
  $slurmctld_port = '6817',
  $slurmdbd_port = '6819',
) inherits slurm::params {

  # Parameter validations
  validate_bool($manage_slurm_user)
  validate_array($partitionlist)
  validate_hash($slurm_conf_override)
  validate_bool($use_auks)
  validate_bool($use_pam)

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
    'PlugStackConfig' => "${conf_dir}/plugstack.conf",
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

  $gid = $slurm::slurm_group_gid ? {
    'UNSET' => undef,
    default => $slurm_group_gid,
  }

  $uid = $slurm::slurm_user_uid ? {
    'UNSET' => undef,
    default => $slurm_user_uid,
  }

  $slurm_conf = merge($slurm_conf_defaults, $slurm_conf_override)

  $slurm_conf_path = "${conf_dir}/slurm.conf"
}
