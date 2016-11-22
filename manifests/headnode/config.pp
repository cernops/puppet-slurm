#
# slurm/config.pp
#   Creates the slurmdb configuration file and ensures that the slurmctl and
#   slurmdb daemons are restarted if the configuration files are modified
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
