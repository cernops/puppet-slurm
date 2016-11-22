#
# slurm/config.pp
#
#

class slurm::config (
  $headnode       = 'slurm01.cern.ch',
  $failover       = 'slurm02.cern.ch',
  $slurmkey       = '/usr/local/slurm/slurm.key',
  $slurmcert      = '/usr/local/slurm/slurm.cert',
  $slurmctld_port = '6817',
  $slurmd_port    = '6818',
  $slurmuser      = 'slurm',
  $scheduler_port = '7321',
  $slurmctld_log  = '/var/log/slurmctld.log',
  $slurmd_log     = '/var/log/slurmd.log',
  $partitionname  = 'batch-testing'
) {

  file{ 'common configuration file':
    ensure  => file,
    path    => '/etc/slurm/slurm.conf',
    content => template('slurm/slurm.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
  }
}
