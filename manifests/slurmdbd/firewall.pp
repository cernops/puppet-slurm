# == Class: slurm::slurmdbd::firewall
#
class slurm::slurmdbd::firewall {

  include slurm

  firewall {'100 allow access to slurmdbd':
    proto   => 'tcp',
    dport   => $slurm::slurmdbd_port,
    action  => 'accept'
  }

}
