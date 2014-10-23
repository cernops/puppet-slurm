# Private class
class slurm::node::service {

  service { 'slurm':
    ensure     => $slurm::slurm_service_ensure,
    enable     => $slurm::slurm_service_enable,
    hasstatus  => false,
    hasrestart => true,
    pattern    => '/usr/sbin/slurm(d|ctld) -f',
  }

}
