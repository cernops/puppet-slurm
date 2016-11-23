#
# slurm/config.pp
#   Ensures that the slurmctl is running
#

class slurm::headnode::config (

) {

  service{'slurmctld':
    ensure    => running,
    subscribe => File['common configuration file'],
  }

}
