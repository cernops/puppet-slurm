# == Class: slurm::client::service
#
class slurm::client::service {

  service { 'slurm':
    ensure      => stopped,
    enable      => false,
    hasstatus   => true,
    hasrestart  => true,
  }

}
