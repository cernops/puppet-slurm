# Private class
class slurm::slurmdbd {

  include ::munge
  include slurm::common::user
  include slurm::common::install
  include slurm::common::setup
  include slurm::slurmdbd::config
  include slurm::slurmdbd::service

  anchor { 'slurm::slurmdbd::start': }
  anchor { 'slurm::slurmdbd::end': }

  Anchor['slurm::slurmdbd::start']->
  Class['::munge']->
  Class['slurm::common::user']->
  Class['slurm::common::install']->
  Class['slurm::common::setup']->
  Class['slurm::slurmdbd::config']->
  Class['slurm::slurmdbd::service']->
  Anchor['slurm::slurmdbd::end']

  if $slurm::manage_firewall {
    firewall {'100 allow access to slurmdbd':
      proto  => 'tcp',
      dport  => $slurm::slurmdbd_port,
      action => 'accept'
    }
  }

}
