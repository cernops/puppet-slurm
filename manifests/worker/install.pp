class slurm::worker::install {
  package {'slurm':
     ensure => $slurm_version,
  }
  package {'slurm-plugins':
     ensure => $slurm_version,
  }
  package {'slurm-munge':
     ensure => $slurm_version,
  }
  package {'auks-slurm':
     ensure => $auks::params::auks_version,
  }
}
