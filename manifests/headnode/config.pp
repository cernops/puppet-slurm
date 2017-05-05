# slurm/headnode/config.pp
#
# Ensures that the slurmctld service is running and restarted if the
# configuration file is modified
#
# version 20170505
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode::config inherits slurm::config {

  $required_files = [
    '/etc/slurm/cgroup.conf',
    '/etc/slurm/plugstack.conf',
    '/etc/slurm/slurm.conf',
    '/etc/slurm/topology.conf',
  ]
  $openssl_credendials = [
    $slurm::config::job_credential_private_key,
    $slurm::config::job_credential_public_certificate,
  ]
  if $slurm::config::crypto_type == 'crypto/openssl' {
    $files = [$required_files, $openssl_credendials]
  }
  else {
    $files = $required_files
  }

  service{'slurmctld':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [
      Package['slurm'],
      File[$files],
    ],
  }
}
