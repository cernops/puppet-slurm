# == Class: slurm::master
#
class slurm::master (
  $manage_slurm_conf = true,
  $manage_state_dir_nfs_mount = false,
  $state_dir_nfs_device = undef,
  $state_dir_nfs_options = 'rw,sync,noexec,nolock,auto',
  $with_devel = false,
  $manage_firewall = true,
  $manage_logrotate = true,
) {

  validate_bool($manage_slurm_conf)
  validate_bool($manage_state_dir_nfs_mount)
  validate_bool($with_devel)
  validate_bool($manage_firewall)
  validate_bool($manage_logrotate)

  anchor { 'slurm::master::start': }
  anchor { 'slurm::master::end': }

  include slurm
  include slurm::user
  include slurm::munge
  include slurm::master::config
  if $slurm::use_auks { include slurm::auks }

  class { 'slurm::install':
    ensure          => $slurm::slurm_package_ensure,
    package_require => $slurm::package_require,
    use_pam         => $slurm::use_pam,
    with_devel      => $with_devel,
  }

  class { 'slurm::config::common':
    slurm_user        => $slurm::slurm_user,
    slurm_user_group  => $slurm::slurm_user_group,
    log_dir           => $slurm::log_dir,
    pid_dir           => $slurm::pid_dir,
    shared_state_dir  => $slurm::shared_state_dir,
  }

  class { 'slurm::config':
    manage_slurm_conf => $manage_slurm_conf,
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

  Anchor['slurm::master::start']->
  Class['slurm::user']->
  Class['slurm::munge']->
  Class['slurm::install']->
  Class['slurm::config::common']->
  Class['slurm::config']->
  Class['slurm::master::config']->
  Class['slurm::service']->
  Anchor['slurm::master::end']

}
