# slurm/headnode/config.pp
#
# Ensures that the slurmctld service is running and restarted if the
# configuration file is modified
#
# version 20170306
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode::config {

  # Starts slurmctld on headnode
  service{'slurmctld':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [Teigi_sub_file['/etc/slurm/slurm.conf'], Package['slurm']],
  }
}
