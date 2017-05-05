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

  $required_files = [
    '/etc/slurm/cgroup.conf',
    '/etc/slurm/plugstack.conf',
    '/etc/slurm/slurm.conf',
    '/etc/slurm/topology.conf',
  ]

  if $slurm::config::crypto_type == 'crypto/openssl' {
    $files = [
      $required_files,
      $slurm::config::job_credential_private_key,
      $slurm::config::job_credential_public_certificate,
    ]
  }
  else {
    $files = $required_files
  }

  service{'slurmd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [
      Package['slurm'],
      File[$files],
    ],
  }
}
