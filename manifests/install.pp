# == Class: slurm::install
#
class slurm::install {

  include slurm

  ensure_packages($slurm::package_runtime_dependencies)

  if $slurm::worker or $slurm::master {
    package { 'slurm': ensure => $slurm::slurm_package_ensure }
    #TODO: slurm-plugins pulled in by slurm package
    package { 'slurm-plugins': ensure => $slurm::slurm_package_ensure }
    package { 'slurm-munge': ensure => $slurm::slurm_package_ensure }
    #TODO: Make dependent on parameter that enables auks usage
    package { 'auks-slurm': ensure => $slurm::auks_package_ensure }
  }

  if $slurm::slurmdb {
    package { 'slurm-slurmdb': ensure => $slurm::slurm_package_ensure }
    package { 'slurm-sql': ensure => $slurm::slurm_package_ensure }
  }

}
