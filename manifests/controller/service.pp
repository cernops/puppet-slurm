# Private class
class slurm::controller::service {

  service { 'slurm':
    ensure     => $slurm::slurm_service_ensure,
    enable     => $slurm::slurm_service_enable,
    hasstatus  => false,
    hasrestart => true,
    pattern    => '/usr/sbin/slurm(d|ctld) -f',
  }

}
