# slurm/workernode/firewall.pp
#
# Firewall rules for the workernode
#
# version 20170301
#
# @param slurmd_port
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::firewall (
  Integer $slurmd_port = 6818,
) {

  firewall{ '201 open slurmd port':
    action => 'accept',
    dport  => $slurmd_port,
    proto  => 'tcp',
  }
}
