class slurm::install {
  package {'munge':
     ensure => 'present',
  }
}
