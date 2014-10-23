# Private class
class slurm::params {

  $slurm_conf_override    = {}
  $partitionlist          = []
  $slurmdbd_conf_override = {}

  $cgroup_allowed_devices = [
    '/dev/null',
    '/dev/urandom',
    '/dev/zero',
    '/dev/sda*',
    '/dev/cpu/*/*',
    '/dev/pts/*',
  ]

  $slurm_conf_defaults = {
    'AccountingStorageType' => 'accounting_storage/slurmdbd',
    'AccountingStoreJobComment' => 'YES',
    'AuthType' => 'auth/munge',
    'CacheGroups' => '0',
    'CheckpointType' => 'checkpoint/none',
    'CompleteWait' => '0',
    'CryptoType' => 'crypto/munge',
    'DefaultStorageType' => 'slurmdbd',
    'DisableRootJobs' => 'NO',
    'EpilogMsgTime' => '2000',
    'FastSchedule' => '1',
    'FirstJobId' => '1',
    'GetEnvTimeout' => '2',
    'GroupUpdateForce' => '0',
    'GroupUpdateTime' => '600',
    'HealthCheckInterval' => '0',
    'HealthCheckNodeState' => 'ANY',
    'InactiveLimit' => '0',
    'JobAcctGatherFrequency' => '30',
    'JobAcctGatherType' => 'jobacct_gather/linux',
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
    'PropagatePrioProcess' => '0',
    'PropagateResourceLimits' => 'ALL',
    'ResvOverRun' => '0',
    'ReturnToService' => '0',
    'SchedulerTimeSlice' => '30',
    'SchedulerType' => 'sched/builtin',
    'SelectType' => 'select/linear',
    'SlurmctldDebug' => '3',
    'SlurmctldTimeout' => '300',
    'SlurmdDebug' => '3',
    'SlurmdTimeout' => '300',
    'SlurmSchedLogLevel' => '0',
    'SwitchType' => 'switch/none',
    'TaskPlugin' => 'task/none',
    'TmpFS' => '/tmp',
    'TopologyPlugin'  => 'topology/none',
    'TrackWCKey' => 'no',
    'TreeWidth' => '50',
    'UsePAM' => '0',
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
    'DebugLevel' => '3',
    'MessageTimeout' => '10',
    'PluginDir' => '/usr/lib64/slurm',
    'TrackSlurmctldDown' => 'no',
  }

  case $::osfamily {
    'RedHat': {
      # do nothing
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
