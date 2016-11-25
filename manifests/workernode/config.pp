#
# slurm/config.pp
#   Ensures that the slurm daemons is restarted if the configuration files is
#   modified
#

class slurm::workernode::config {

  # Starts slurmd on WN
  service{'slurm':
    ensure    => running,
    subscribe => [File['common configuration file']],
  }
}
