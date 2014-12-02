# Private class
class slurm::node::service {

  service { 'slurmd':
    ensure     => $slurm::slurm_service_ensure,
    enable     => $slurm::slurm_service_enable,
    name       => 'slurm',
    hasstatus  => false,
    hasrestart => true,
    pattern    => '/usr/sbin/slurmd -f',
  }

}
