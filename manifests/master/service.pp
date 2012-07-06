class slurm::master::service {
  service { "slurm":
           ensure     => running,
           hasstatus  => true,
           hasrestart => true,
           enable     => true,
           require    => Class["slurm::master::config"];
  }
}
