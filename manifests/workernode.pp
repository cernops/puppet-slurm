# slurm/workernode.pp
#
# Puts SLURM on workernode.
#
# version 20170816
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode {

  include ::slurm::setup
  include ::slurm::config
  include ::slurm::workernode::setup
  include ::slurm::workernode::config

  Class['::slurm::setup'] -> Class['::slurm::config'] -> Class['::slurm::workernode::setup'] -> Class['::slurm::workernode::config']
}
