class slurm::service {
  service { "munge":
           ensure     => running,
           hasstatus  => true,
           hasrestart => true,
           enable     => true,
           require    => Class["slurm::config"];
  }
}
