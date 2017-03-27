# slurm/workernode/config.pp
#
# Ensures that the slurmd service is running and restarted if the
# configuration file is modified
#
# version 20170327
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::config {

  service{'slurmd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [
      Package['slurm'],
      Teigi_sub_file['/etc/slurm/slurm.conf'],
      File[
        '/etc/slurm/cgroup.conf',
        '/etc/slurm/plugstack.conf',
        '/etc/slurm/topology.conf',
      ],
    ],
  }
}
