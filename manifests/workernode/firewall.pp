# slurm/workernode/firewall.pp
#
# Firewall rules for the workernode.
#
# @param slurmd_port The port number that the Slurm compute node daemon, slurmd, listens to.
#
# version 20170602
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::firewall {

  if ($slurm::config::open_firewall) {
    firewall{ '201 open slurmd port':
      action => 'accept',
      dport  => $slurm::config::slurmd_port,
      proto  => 'tcp',
    }
  }
}
