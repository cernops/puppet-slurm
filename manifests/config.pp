#
# slurm/config.pp
#   Creates the commun configuration file
#

class slurm::config (
  $headnode              = 'headnode1.example.org',
  $failover              = 'headnode2.example.org',
  $checkpoint_dir        = '/var/slurm/checkpoint',
  $slurmkey_loc          = '/usr/local/slurm/credentials/slurm.key',
  $slurmcert_loc         = '/usr/local/slurm/credentials/slurm.cert',
  $maxjobcount           = '5000',
  $plugin_dir            = '/usr/lib64/slurm',
  $plugstackconf_file    = '/etc/slurm/plugstack.conf',
  $slurmctld_port        = '6817',
  $slurmd_port           = '6818',
  $slurmdspool_dir       = '/var/spool/slurmd',
  $slurmuser             = 'slurm',
  $accounting_db_host    = 'accountingdb.example.org',
  $accounting_db_loc     = 'accountingdb',
  $accounting_db_port    = '6819',
  $accounting_db_user    = 'slurm',
  $clustername           = 'batch',
  $jobcomp_db_host       = 'jobcompdb.example.org',
  $jobcomp_db_loc        = 'jobcompdb',
  $jobcomp_db_port       = '6819',
  $jobcomp_db_user       = 'slurm',
  $slurmctld_log         = '/var/log/slurmctld.log',
  $slurmd_log            = '/var/log/slurmd.log',
  $workernodes           = [{'NodeName' => 'worker[00-10]', 'CPUs' => '16'}],
  $partitions            = [{'PartitionName' => 'workers', 'MaxMemPerCPU' => '2000'}],
) {

  teigi::secret::sub_file{'/etc/slurm/slurm.conf':
    teigi_keys => ['slurmdbpass'],
    template   => 'slurm/slurm.conf.erb',
    owner      => 'slurm',
    group      => 'slurm',
    mode       => '0644',
  }

  service{'munge':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [File['munge homedir'], Package['slurm-munge','munge','munge-libs','munge-devel'], Teigi_secret['munge secret key']],
  }
}
