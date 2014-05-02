# == Class: slurm::munge
#
class slurm::munge {

  include slurm

  package { 'munge':
    ensure  => $slurm::munge_package_ensure,
    before  => File['/etc/munge/munge.key'],
    require => Yumrepo['epel'],
  }

  file { '/etc/munge/munge.key':
    ensure  => 'file',
    owner   => 'munge',
    group   => 'munge',
    mode    => '0400',
    source  => $slurm::munge_key,
    before  => Service['munge'],
  }

  service { 'munge':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }

}
