# == Class: slurm::worker::service
#
class slurm::worker::service {

  service { 'slurm':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }

}
