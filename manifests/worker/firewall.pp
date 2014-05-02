# == Class: slurm::worker::firewall
#
class slurm::worker::firewall {

  include slurm

  firewall { '100 allow access to slurmd':
    proto   => 'tcp',
    dport   => $slurm::slurmd_port,
    action  => 'accept'
  }

}
