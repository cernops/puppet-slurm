# == Class: slurm::install
#
class slurm::install (
  $ensure = 'present',
  $package_require = undef,
  $use_pam = false,
  $with_devel = false,
  $install_torque_wrapper = true,
  $with_lua = false,
  $with_blcr = false,
  $install_blcr = false,
  $install_tools = false,
) {

  include slurm

  Package {
    ensure  => $ensure,
    require => $package_require,
  }

  package { 'slurm': }
  package { 'slurm-munge': }
  package { 'slurm-plugins': }

  if $with_devel              { package { 'slurm-devel': } }
  if $use_pam                 { package { 'slurm-pam_slurm': } }
  if $install_torque_wrapper  { package { 'slurm-torque': } }
  if $with_lua                { package { 'slurm-lua': } }
  if $with_blcr               { package { 'slurm-blcr': } }

  # TODO: Move to blcr module
  if $install_blcr {
    $blcr_modules_kernel = regsubst($::kernelrelease, '-', '_')
    package { 'blcr': ensure => 'installed' }
    package { 'blcr-libs': ensure => 'installed' }
    package { 'blcr-devel': ensure => 'installed' }
    package { 'blcr-modules':
      ensure  => 'installed',
      name    => "blcr-modules_${blcr_modules_kernel}"
    }
  }

  if $install_tools {
    package { 'slurm-sjstat': }
    package { 'slurm-perlapi': }
  }
}
