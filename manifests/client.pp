# == Class: slurm::client
#
class slurm::client (
  $manage_slurm_conf = true,
  $manage_scripts = false,
  $with_devel = false,
  $install_torque_wrapper = true,
  $with_lua = false,
  $with_blcr = false,
  $install_blcr = false,
  $install_tools = true,
) {

  validate_bool($manage_slurm_conf)
  validate_bool($manage_scripts)
  validate_bool($with_devel)
  validate_bool($install_torque_wrapper)
  validate_bool($with_lua)
  validate_bool($with_blcr)
  validate_bool($install_blcr)
  validate_bool($install_tools)

  include ::munge
  include slurm
  include slurm::user
  include slurm::config::common

  anchor { 'slurm::client::start': }
  anchor { 'slurm::client::end': }

  class { 'slurm::install':
    ensure                  => $slurm::slurm_package_ensure,
    package_require         => $slurm::package_require,
    use_pam                 => $slurm::use_pam,
    with_devel              => $with_devel,
    install_torque_wrapper  => $install_torque_wrapper,
    with_lua                => $with_lua,
    with_blcr               => $with_blcr,
    install_blcr            => $install_blcr,
    install_tools           => $install_tools,
  }

  class { 'slurm::config':
    manage_slurm_conf => $manage_slurm_conf,
    manage_scripts    => $manage_scripts,
  }

  class { 'slurm::service':
    ensure  => 'stopped',
    enable  => false,
  }

  Anchor['slurm::client::start']->
  Class['::munge']->
  Class['slurm::user']->
  Class['slurm::install']->
  Class['slurm::config::common']->
  Class['slurm::config']->
  Class['slurm::service']->
  Anchor['slurm::client::end']

}
