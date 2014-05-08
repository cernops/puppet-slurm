# == Class: slurm::master::service
#
class slurm::master::service {

  service { 'slurm':
    ensure      => running,
    enable      => true,
    hasstatus   => false,
    hasrestart  => true,
    pattern     => '/usr/sbin/slurm(d|ctld)$',
  }

}
