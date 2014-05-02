# == Class: slurm::user
#
class slurm::user {

  include slurm

  if $slurm::manage_slurm_user {
    group { 'slurm':
      ensure  => present,
      name    => $slurm::slurm_user_group,
      gid     => $slurm::gid,
    }

    user { 'slurm':
      ensure  => present,
      name    => $slurm::slurm_user,
      uid     => $slurm::uid,
      gid     => $slurm::slurm_user_group,
      shell   => $slurm::slurm_user_shell,
      home    => $slurm::slurm_user_home,
      comment => $slurm::slurm_user_comment,
    }
  }

}
