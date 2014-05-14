# == Class: slurm::install
#
class slurm::install (
  $ensure = 'present',
  $package_require = undef,
  $use_pam = false,
  $with_devel = false,
) {

  include slurm

  ensure_packages($slurm::package_runtime_dependencies)

  Package {
    ensure  => $ensure,
    require => $package_require,
  }

  package { 'slurm': }
  package { 'slurm-munge': }
  package { 'slurm-plugins': }

  if $with_devel  { package { 'slurm-devel': } }
  if $use_pam     { package { 'slurm-pam_slurm': } }

}
