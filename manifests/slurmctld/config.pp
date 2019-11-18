# @api private
class slurm::slurmctld::config {
  file { 'StateSaveLocation':
    ensure => 'directory',
    path   => $slurm::state_save_location,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_user_group,
    mode   => '0700',
  }

  file { 'JobCheckpointDir':
    ensure => 'directory',
    path   => $slurm::job_checkpoint_dir,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_user_group,
    mode   => '0700',
  }

  if $slurm::manage_state_dir_nfs_mount {
    mount { 'StateSaveLocation':
      ensure  => 'mounted',
      name    => $slurm::state_save_location,
      atboot  => true,
      device  => $slurm::state_dir_nfs_device,
      fstype  => 'nfs',
      options => $slurm::state_dir_nfs_options,
      require => File['StateSaveLocation'],
    }
  }

  if $slurm::manage_job_checkpoint_dir_nfs_mount {
    mount { 'JobCheckpointDir':
      ensure  => 'mounted',
      name    => $slurm::job_checkpoint_dir,
      atboot  => true,
      device  => $slurm::job_checkpoint_dir_nfs_device,
      fstype  => 'nfs',
      options => $slurm::job_checkpoint_dir_nfs_options,
      require => File['JobCheckpointDir'],
    }
  }
}
