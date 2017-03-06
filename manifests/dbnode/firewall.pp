# slurm/dbnode/firewall.pp
#
# Firewall rules for the dbnode
#
# @param accounting_storage_port
#
# version 20170306
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::firewall (
  Integer $accounting_storage_port = 6819,
) {

  firewall{ '203 open slurmdbd port':
    action => 'accept',
    dport  => $accounting_storage_port,
    proto  => 'tcp',
  }
}
