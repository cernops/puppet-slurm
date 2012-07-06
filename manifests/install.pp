class slurm::install {
  package {'munge':
     ensure => 'latest',
  }
}
