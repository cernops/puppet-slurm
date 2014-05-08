# == Class: slurm::worker::service
#
class slurm::worker::service {

  service { 'slurm':
    ensure      => running,
    enable      => true,
    hasstatus   => false,
    hasrestart  => true,
    pattern     => '/usr/sbin/slurm(d|ctld)$',
  }

}
