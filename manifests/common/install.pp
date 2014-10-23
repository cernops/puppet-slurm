# Private class
class slurm::common::install {

  Package {
    ensure  => $slurm::version,
    require => $slurm::package_require,
  }

  if $slurm::node or $slurm::controller or $slurm::client {
    package { 'slurm': }
    package { 'slurm-devel': }
    package { 'slurm-munge': }
    package { 'slurm-perlapi': }
    package { 'slurm-plugins': }
    package { 'slurm-sjobexit': }
    package { 'slurm-sjstat': }
  }

  if $slurm::slurmdbd {
    package { 'slurm-slurmdbd': }
    package { 'slurm-sql': }
  }

  if $slurm::install_pam            { package { 'slurm-pam_slurm': } }
  if $slurm::install_torque_wrapper { package { 'slurm-torque': } }
  if $slurm::install_lua            { package { 'slurm-lua': } }
  if $slurm::install_blcr           { package { 'slurm-blcr': } }

}
