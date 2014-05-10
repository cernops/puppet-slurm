# == Class: slurm::client::service
#
class slurm::client::service {

  service { 'slurm':
    ensure      => stopped,
    enable      => false,
    hasstatus   => false,
    hasrestart  => true,
    pattern     => '/usr/sbin/slurm(d|ctld)$',
  }

}
