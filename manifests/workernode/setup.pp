# slurm/workernode/setup.pp
#
# Creates folders/logfiles and installs packages specific to workernode
#
# @param slurmd_loc
# @param slurmd_log_file
# @param packages
#
# version 20170306
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::setup (
  String $slurmd_loc      = '/var/spool/slurmd',
  String $slurmd_log_file = '/var/log/slurm/slurmd.log',
  Array $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-torque',
  ],
) {

  ensure_packages($packages)

  file{ 'slurmd folder':
    ensure => directory,
    path   => $slurmd_loc,
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
  }

  file{ 'slurmd log':
    ensure => file,
    path   => $slurmd_log_file,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  logrotate::file{ 'slurmd':
    log     => $slurmd_log_file,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }
}
