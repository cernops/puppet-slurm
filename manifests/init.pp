# slurm/init.pp
#
# Installs SLURM with configuration according to node type
#
# @param node_type Specifies the node type which defines the configuration that will be applied to that node
#
# version 20170327
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm (
  String $node_type = '',
) {

  case $node_type {
    'worker': {
      class{'::slurm::workernode':}
    }
    'head': {
      class{'::slurm::headnode':}
    }
    'db': {
      class{'::slurm::dbnode':}
    }
    'db-head': {
      class{'::slurm::headnode':}
      class{'::slurm::dbnode':}
    }
    default: {
      err('No role specified! Please provide one in hiera.')
    }
  }
}
