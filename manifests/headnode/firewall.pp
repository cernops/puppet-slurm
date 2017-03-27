# slurm/headnode/firewall.pp
#
# Common firewall rules for the headnode
#
# @param slurmctld_port The port number that the Slurm controller, slurmctld, listens to for work
#
# version 20170327
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode::firewall {

  firewall{ '200 open slurmctld port':
    action => 'accept',
    dport  => $slurm::config::slurmctld_port,
    proto  => 'tcp',
  }
}
