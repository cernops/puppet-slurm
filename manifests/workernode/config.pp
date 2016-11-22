#
# slurm/config.pp
#   Ensures that the slurm daemons is restarted if the configuration files is
#   modified
#

class slurm::workernode::config {

  service{'slurmd':
    ensure    => running,
    subscribe => File['common configuration file'],
  }
}
