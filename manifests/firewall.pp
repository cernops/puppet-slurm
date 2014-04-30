# == Class: slurm::firewall
#
class slurm::firewall {

  include slurm

  if $slurm::worker and $slurm::manage_firewall {
    firewall { '100 allow access to slurmd':
      proto   => 'tcp',
      dport   => $slurm::slurmd_port,
      action  => 'accept'
    }
  }

  if $slurm::master and $slurm::manage_firewall {
    firewall { '100 allow access to slurmctld':
      proto   => 'tcp',
      dport   => $slurm::slurmctld_port,
      action  => 'accept'
    }
  }

  if $slurm::slurmdb and $slurm::manage_firewall {
    firewall {'100 allow access to slurmdbd':
      proto   => 'tcp',
      dport   => $slurm::slurmdbd_port,
      action  => 'accept'
    }
  }

}
