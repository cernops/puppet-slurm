#
# slurm/config.pp
#   Creates the slurmdb configuration file and ensures that the
#   slurmdb daemon are restarted if the configuration files are modified
#

class slurm::dbnode::config {

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
