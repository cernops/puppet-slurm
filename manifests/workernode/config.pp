#
# slurm/config.pp
#   Ensures that the slurm daemons is restarted if the configuration files is
#   modified
#

class slurm::workernode::config($workernodes = []) {

  # PuppetDB lookup for many nodes.. check if OK.
  $hostgroup = 'bi/hpc/batch/workernode'
  $workernodes =  sort(unique(query_nodes("hostgroup=\"$hostgroup\"", 'fqdn')))

  service{'slurmd':
    ensure    => running,
    subscribe => File['common configuration file'],
  }
}
