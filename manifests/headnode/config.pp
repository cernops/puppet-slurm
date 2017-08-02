# slurm/headnode/config.pp
#
# Ensures that the slurmctld service is running and restarted if the configuration file is modified.
#
# version 20170802
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode::config {

  service{'slurmctld':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [
      Package['slurm'],
      File[$slurm::config::required_files],
    ],
  }

  if ($slurm::config::open_firewall) {
    firewall{ '200 open slurmctld port':
      action => 'accept',
      dport  => $slurm::config::slurmctld_port,
      proto  => 'tcp',
    }
  }
}
