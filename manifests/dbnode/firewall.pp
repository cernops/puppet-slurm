# slurm/dbnode/firewall.pp
#
# Firewall rules for the dbnode
#
# version 20170301
#
# @param slurmdbd_port
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::firewall (
  Integer $slurmdbd_port = 6819,
) {

  firewall{ '203 open slurmdbd port':
    action => 'accept',
    dport  => $slurmdbd_port,
    proto  => 'tcp',
  }
}
