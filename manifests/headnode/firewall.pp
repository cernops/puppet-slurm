#
# slurm/headnode/firewall.pp
#   Common firewall rules for the headnode
#

class slurm::headnode::firewall (
  $slurmctld_port = '6817',
  $slurmd_port    = '6818',
  $scheduler_port = '7321',
) {

  firewall{ '200 open slurmctld port':
    action => 'accept',
    dport  => $slurmctld_port,
    proto  => 'all',
  }

  firewall{ '201 open slurmd port':
    action => 'accept',
    dport  => $slurmd_port,
    proto  => 'all',
  }

  firewall{ '202 open scheduler port':
    action => 'accept',
    dport  => $scheduler_port,
    proto  => 'all',
  }
}
