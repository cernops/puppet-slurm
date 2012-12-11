class slurm::slurmdb::install {
  package {'mysql-server':
     ensure => 'present',
  }
  package {'slurm-slurmdbd':
     ensure => $slurm::params::slurm_version,
  }
  package {'slurm-sql':
     ensure => $slurm::params::slurm_version,
  }
}
