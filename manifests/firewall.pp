#
# slurm/firewall.pp
#
#

class slurm::firewall {
  # Common firewall rules for the headnode & workernode (let's at least try having a firewall)
  #
  # I.e. puppetize these default ports to be open on WNs and HN.
  # SlurmctldPort=6817
  # SlurmdPort=6818
  # SchedulerPort=7321
}
