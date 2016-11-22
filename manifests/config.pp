#
# slurm/config.pp
#   
#

class slurm::config (

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
