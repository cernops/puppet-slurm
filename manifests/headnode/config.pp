#
# slurm/config.pp
#
#

class slurm::headnode::config (

) {

  service{'slurmctld':
    ensure    => running,
    subscribe => File['common configuration file'],
  }

  file{ 'slurmdb configuration file':
    ensure  => file,
    path    => '/etc/slurm/slurmdbd.conf',
    content => template('slurm/slurmdbd.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
  }
  service{'slurmdbd':
    ensure    => running,
    subscribe => File['slurmdb configuration file'],
  }
}
