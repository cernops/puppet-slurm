#
# slurm/headnode/config.pp
#   Ensures that the slurmctld service is running and restarted if the
#   configuration file is modified
#

class slurm::headnode::config {

  # Starts slurmctld on headnode
  service{'slurmctld':
    ensure    => running,
    enable    => true,
    subscribe => Teigi_sub_file['/etc/slurm/slurm.conf'],
  }
}
