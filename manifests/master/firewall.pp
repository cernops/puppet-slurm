# == Class: slurm::master::firewall
#
class slurm::master::firewall {

  include slurm

  firewall { '100 allow access to slurmctld':
    proto   => 'tcp',
    dport   => $slurm::slurmctld_port,
    action  => 'accept'
  }

}
