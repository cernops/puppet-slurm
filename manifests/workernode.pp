# slurm/workernode.pp
#
# Puts SLURM on workernode
#
# version 20170301
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode {

  include ::slurm::workernode::firewall
  include ::slurm::setup
  include ::slurm::workernode::setup
  include ::slurm::config
  include ::slurm::workernode::config

  Class['::slurm::setup']->
  Class['::slurm::workernode::setup']->
  Class['::slurm::config']->
  Class['::slurm::workernode::config']
}
