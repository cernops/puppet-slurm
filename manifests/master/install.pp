class slurm::master::install {
  package {'nfs-utils':
     ensure => 'present',
  }
  package {'slurm':
     ensure => $slurm::params::slurm_version,
  }
  package {'slurm-plugins':
     ensure => $slurm::params::slurm_version,
  }
  package {'slurm-munge':
     ensure => $slurm::params::slurm_version,
  }
  package {'auks-slurm':
     ensure => $auks::params::auks_version,
  }
}
