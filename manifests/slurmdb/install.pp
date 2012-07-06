class slurm::slurmdb::install {
  package {'mysql-server':
     ensure => 'latest',
  }
  package {'slurm-slurmdbd':
     ensure => $slurm_version,
  }
  package {'slurm-sql':
     ensure => $slurm_version,
  }
}
