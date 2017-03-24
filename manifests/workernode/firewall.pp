# slurm/workernode/firewall.pp
#
# Firewall rules for the workernode
#
# @param slurmd_port The port number that the Slurm compute node daemon, slurmd, listens to for work
#
# version 20170327
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::firewall (
  Integer $slurmd_port = $slurm::config::slurmd_port,
) {

  firewall{ '201 open slurmd port':
    action => 'accept',
    dport  => $slurmd_port,
    proto  => 'tcp',
  }
}
