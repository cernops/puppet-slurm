# == Class: slurm::controller
#
class slurm::controller (
  $manage_slurm_conf = true,
  $manage_state_dir_nfs_mount = false,
  $state_dir_nfs_device = undef,
  $state_dir_nfs_options = 'rw,sync,noexec,nolock,auto',
  $with_devel = false,
  $install_torque_wrapper = true,
  $manage_firewall = true,
  $manage_logrotate = true,
) {

  validate_bool($manage_slurm_conf)
  validate_bool($manage_state_dir_nfs_mount)
  validate_bool($with_devel)
  validate_bool($install_torque_wrapper)
  validate_bool($manage_firewall)
  validate_bool($manage_logrotate)

  anchor { 'slurm::controller::start': }
  anchor { 'slurm::controller::end': }

  include slurm
  include slurm::user
  include slurm::munge
  include slurm::config::common
  if $slurm::use_auks { include slurm::auks }

  class { 'slurm::install':
    ensure                  => $slurm::slurm_package_ensure,
    package_require         => $slurm::package_require,
    use_pam                 => $slurm::use_pam,
    with_devel              => $with_devel,
    install_torque_wrapper  => $install_torque_wrapper,
  }

  class { 'slurm::config':
    manage_slurm_conf => $manage_slurm_conf,
  }

  class { 'slurm::controller::config':
    manage_state_dir_nfs_mount  => $manage_state_dir_nfs_mount,
    state_dir_nfs_device        => $state_dir_nfs_device,
    state_dir_nfs_options       => $state_dir_nfs_options,
    manage_logrotate            => $manage_logrotate,
  }

  class { 'slurm::service':
    ensure  => 'running',
    enable  => true,
  }

  if $manage_firewall {
    firewall { '100 allow access to slurmctld':
      proto   => 'tcp',
      dport   => $slurm::slurmctld_port,
      action  => 'accept'
    }
  }

  Anchor['slurm::controller::start']->
  Class['slurm::user']->
  Class['slurm::munge']->
  Class['slurm::install']->
  Class['slurm::config::common']->
  Class['slurm::config']->
  Class['slurm::controller::config']->
  Class['slurm::service']->
  Anchor['slurm::controller::end']

}
