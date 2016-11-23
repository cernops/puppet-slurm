#
# slurm/config.pp
#   Ensures that the slurm daemons is restarted if the configuration files is
#   modified
#

class slurm::workernode::config($hostgroup = '') {

  # PuppetDB lookup for many nodes.. check if OK.
  $workernodes =  sort(unique(query_nodes("hostgroup=\"$hostgroup\"", 'fqdn')))

  service{'slurmd':
    ensure    => running,
    subscribe => File['common configuration file'],
  }
}
