# == Class: slurm::slurmdbd::install
#
class slurm::slurmdbd::install {

  include slurm

  ensure_packages($slurm::package_runtime_dependencies)

  package { 'slurm-slurmdbd': ensure => $slurm::slurm_package_ensure }

}
