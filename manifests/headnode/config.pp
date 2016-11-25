#
# slurm/config.pp
#   Ensures that the slurmctl is running
#

class slurm::headnode::config {

  # Starts slurmctld on headnode
  service{'slurm':
    ensure    => running,
    subscribe => File['common configuration file'],
  }

}
