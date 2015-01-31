# Private class
class slurm::controller::service {

  service { 'slurmctld':
    ensure     => $slurm::slurm_service_ensure,
    enable     => $slurm::slurm_service_enable,
    name       => 'slurm',
    hasstatus  => false,
    hasrestart => true,
    pattern    => "slurmctld -f ${slurm::slurm_conf_path}",
  }

}
