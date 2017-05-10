# slurm/workernode/config.pp
#
# Ensures that the slurmd service is running and restarted if the
# configuration file is modified
#
# version 20170505
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::config inherits slurm::config {

  service{'slurmd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [
      Package['slurm'],
      File[$slurm::config::hnwn_required_files],
    ],
  }
}
