#
# slurm/config.pp
#   Creates the commun configuration file
#

class slurm::config (
  $headnode           = 'headnode1.example.org',
  $failover           = 'headnode2.example.org',
  $checkpoint_dir     = '/var/slurm/checkpoint',
  $slurmkey_loc       = '/usr/local/slurm/credentials/slurm.key',
  $slurmcert_loc      = '/usr/local/slurm/credentials/slurm.cert',
  $maxjobcount        = '5000',
  $plugin_dir         = '/usr/lib64/slurm',
  $plugstackconf_file = '/etc/slurm/plugstack.conf',
  $slurmctld_port     = '6817',
  $slurmd_port        = '6818',
  $slurmdspool_dir    = '/var/spool/slurmd',
  $slurmstate_dir     = '/var/spool/slurmctld/slurm.state',
  $slurmuser          = 'slurm',
  $slurmdbd_host      = 'accountingdb.example.org',
  $slurmdbd_loc       = 'accountingdb',
  $slurmdbd_port      = '6819',
  $slurmdbd_user      = 'slurm',
  $clustername        = 'batch',
  $jobcomp_db_host    = 'jobcompdb.example.org',
  $jobcomp_db_loc     = 'jobcompdb',
  $jobcomp_db_port    = '6819',
  $jobcomp_db_user    = 'slurm',
  $slurmctld_log      = '/var/log/slurm/slurmctld.log',
  $slurmd_log         = '/var/log/slurm/slurmd.log',
  $workernodes        = [{'NodeName' => 'worker[00-10]', 'CPUs' => '16'}],
  $partitions         = [{'PartitionName' => 'workers', 'MaxMemPerCPU' => '2000'}],
) {

  teigi::secret::sub_file{'/etc/slurm/slurm.conf':
    teigi_keys => ['slurmdbpass'],
    content    => template('slurm/slurm.conf.erb'),
    owner      => 'slurm',
    group      => 'slurm',
    mode       => '0644',
  }

  file{'/etc/slurm/acct_gather.conf':
    ensure  => file,
    content => template('slurm/acct_gather.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
  }

  file{ $slurmdbd_loc :
    ensure  => file,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
  }

  file{ $jobcomp_db_loc :
    ensure  => file,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
  }

  service{'munge':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => File['munge homedir','/etc/munge/munge.key'],
  }
}
