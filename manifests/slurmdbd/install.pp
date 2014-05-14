# == Class: slurm::slurmdbd::install
#
class slurm::slurmdbd::install (
  $ensure = 'present',
  $package_require = undef,
) {

  include slurm

  ensure_packages($slurm::package_runtime_dependencies)

  Package {
    ensure  => $ensure,
    require => $package_require,
  }

  package { 'slurm-slurmdbd': }
  package { 'slurm-sql': }

}
