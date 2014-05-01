# == Class: slurm::munge
#
class slurm::munge {

  include slurm

  $munge_key = $slurm::munge_key ? {
    'UNSET' => undef,
    default => $slurm::munge_key,
  }

  #TODO: Remove as pulled in by slurm-munge
  package { 'munge':
    ensure  => $slurm::munge_package_ensure,
    before  => File['/etc/munge/munge.key'],
  }

  file { '/etc/munge/munge.key':
    ensure  => 'file',
    owner   => 'munge',
    group   => 'munge',
    mode    => '0400',
    source  => $munge_key,
    before  => Service['munge'],
  }

  service { 'munge':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }

}
