# Private class
class slurm::slurmdbd::service {

  service { 'slurmdbd':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }

}
