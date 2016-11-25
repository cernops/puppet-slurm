#
# slurm/headnode/firewall.pp
#   Common firewall rules for the headnode
#

class slurm::headnode::firewall (
  $slurmctld_port = '6817',
) {

  firewall{ '200 open slurmctld port':
    action => 'accept',
    dport  => $slurmctld_port,
    proto  => 'tcp',
  }
}
