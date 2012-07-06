class slurm::master::install {
  package {'nfs-utils':
     ensure => 'latest',
  }
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
     ensure => '0.4.0-1CERN2.ai6',
  }
}
