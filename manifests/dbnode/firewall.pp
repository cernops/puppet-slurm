#
# slurm/dbnode/firewall.pp
#   Common firewall rules for the dbnode
#

class slurm::dbnode::firewall (
  $slurmdbd_port  = '6819',
) {

  firewall{ '203 open slurmdbd port':
    action => 'accept',
    dport  => $slurmdbd_port,
    proto  => 'all',
  }
}
