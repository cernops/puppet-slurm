# == Class: slurm::worker::install
#
class slurm::worker::install {

  include slurm

  ensure_packages($slurm::package_runtime_dependencies)

  package { 'slurm': ensure => $slurm::slurm_package_ensure }
  package { 'slurm-munge': ensure => $slurm::slurm_package_ensure }

  if $slurm::use_pam {
    package { 'slurm-pam_slurm': ensure => $slurm::slurm_package_ensure }
  }

}
