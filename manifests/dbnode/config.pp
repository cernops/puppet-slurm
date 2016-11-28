#
# slurm/config.pp
#   Creates the slurmdb configuration file and ensures that the
#   slurmdb daemon are restarted if the configuration files are modified
#

class slurm::dbnode::config {

  file{ '/etc/slurm/slurmdbd.conf':
    ensure  => file,
    content => template('slurm/slurmdbd.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
  }
  service{'slurmdb':
    ensure    => running,
    subscribe => File['/etc/slurm/slurm.conf','/etc/slurm/slurmdbd.conf'],
  }
}
