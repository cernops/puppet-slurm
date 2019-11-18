# @api private
class slurm::common::user {

  if $slurm::manage_slurm_user {
    group { 'slurm':
      ensure     => present,
      name       => $slurm::slurm_user_group,
      gid        => $slurm::slurm_group_gid,
      forcelocal => true,
    }

    user { 'slurm':
      ensure     => present,
      name       => $slurm::slurm_user,
      uid        => $slurm::slurm_user_uid,
      gid        => $slurm::slurm_user_group,
      shell      => $slurm::slurm_user_shell,
      home       => $slurm::slurm_user_home,
      managehome => $slurm::slurm_user_managehome,
      comment    => $slurm::slurm_user_comment,
      forcelocal => true,
    }
  }

}
