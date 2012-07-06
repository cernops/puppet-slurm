class slurm::slurmdb::service {
  service { "mysqld":
           ensure     => running,
           hasstatus  => true,
           hasrestart => true,
           enable     => true,
           require    => Class["slurm::slurmdb::config"];
  }
  service { "slurmdbd":
           ensure     => running,
           hasstatus  => true,
           hasrestart => true,
           enable     => true,
           require    => Class["slurm::slurmdb::config"];
  }
}
