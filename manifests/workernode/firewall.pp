#
# slurm/workernode/firewall.pp
#   Firewall rules for the workernode
#

class slurm::workernode::firewall (
  $slurmd_port    = '6818',
) {

  firewall{ '201 open slurmd port':
    action => 'accept',
    dport  => $slurmd_port,
    proto  => 'tcp',
  }
}
