# slurm/headnode.pp
#
# Puts SLURM on headnode.
#
# version 20170602
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode {

  include ::slurm::headnode::firewall
  include ::slurm::setup
  include ::slurm::headnode::setup
  include ::slurm::config
  include ::slurm::headnode::config

  Class['::slurm::setup'] -> Class['::slurm::headnode::setup'] -> Class['::slurm::config'] -> Class['::slurm::headnode::config']
}
