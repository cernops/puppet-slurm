# slurm/client.pp
#
# Puts SLURM on any client. No service other than munge with run.
#
# version 20190101
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::client {

  include ::slurm::setup
  include ::slurm::config

  Class['::slurm::setup'] -> Class['::slurm::config']
}
