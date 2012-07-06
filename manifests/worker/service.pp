class slurm::worker::service {

  service { "slurm":
           ensure     => running,
           hasstatus  => true,
           hasrestart => true,
           enable     => true,
           require    => Class["slurm::worker::config"];
  }
}
