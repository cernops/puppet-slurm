# == Class: slurm::auks
#
class slurm::auks {

  include slurm

  package { 'auks-slurm': ensure => $slurm::auks_package_ensure }

  file { '/etc/slurm/plugstack.conf.d/auks.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/plugstack.conf.d/auks.conf.erb'),
    require => File['plugstack.conf.d'],
  }

#  shellvar { 'slurm KRB5CCNAME':
#    ensure    => present,
#    variable  => 'KRB5CCNAME',
#    target    => '/etc/sysconfig/slurm',
#    value     => '',
#  }

}
