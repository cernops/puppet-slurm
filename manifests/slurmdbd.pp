# @api private
class slurm::slurmdbd {

  contain ::munge
  contain slurm::common::user
  contain slurm::common::install
  contain slurm::common::setup
  contain slurm::slurmdbd::config
  contain slurm::slurmdbd::service

  Class['::munge']
  -> Class['slurm::common::user']
  -> Class['slurm::common::install']
  -> Class['slurm::common::setup']
  -> Class['slurm::slurmdbd::config']
  -> Class['slurm::slurmdbd::service']

  if $slurm::manage_firewall {
    firewall {'100 allow access to slurmdbd':
      proto  => 'tcp',
      dport  => $slurm::slurmdbd_port,
      action => 'accept'
    }
  }

}
