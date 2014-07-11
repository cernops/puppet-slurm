# == Class: slurm::slurmdbd::install
#
class slurm::slurmdbd::install (
  $ensure = 'present',
  $package_require = undef,
) {

  include slurm

  Package {
    ensure  => $ensure,
    require => $package_require,
  }

  package { 'slurm-slurmdbd': }
  package { 'slurm-sql': }

}
