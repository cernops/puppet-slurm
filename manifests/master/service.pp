# == Class: slurm::master::service
#
class slurm::master::service {

  service { 'slurm':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }

}
