#
# slurm/headnode/firewall.pp
#   Common firewall rules for the headnode and workernode
#

class slurm::headnode::firewall (
  $slurmctld_port = '6817',
  $slurmd_port    = '6818',
  $slurmdbd_port  = '6819',
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

  firewall{ '202 open slurmdbd port':
    action => 'accept',
    dport  => $slurmdbd_port,
    proto  => 'all',
  }
  firewall{ '203 open scheduler port':
    action => 'accept',
    dport  => $scheduler_port,
    proto  => 'all',
  }
}
