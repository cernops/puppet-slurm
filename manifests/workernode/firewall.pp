#
# slurm/headnode/firewall.pp
#   Firewall rules for the headnode
#

class slurm::headnode::firewall (
  $slurmd_port    = '6818',
) {

  firewall{ '201 open slurmd port':
    action => 'accept',
    dport  => $slurmd_port,
    proto  => 'all',
  }
}
