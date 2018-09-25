# slurm/dbnode.pp
#
# Puts SLURM on dbnode.
#
# version 20170816
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode {

  include ::slurm::setup
  include ::slurm::config
  include ::slurm::dbnode::setup
  include ::slurm::dbnode::config

  Class['::slurm::setup'] -> Class['::slurm::config'] -> Class['::slurm::dbnode::setup'] -> Class['::slurm::dbnode::config']
}
