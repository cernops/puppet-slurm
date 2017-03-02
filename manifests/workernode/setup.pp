# slurm/workernode/setup.pp
#
# Creates folders/logfiles and installs packages specific to workernode
#
# version 20170301
#
# @param slurmd_folder
# @param slurmd_log
# @param packages
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::setup (
  String $slurmd_folder = '/var/spool/slurmd',
  String $slurmd_log    = '/var/log/slurm/slurmd.log',
  Array $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-sjobexit',
    'slurm-sjstat',
    'slurm-torque',
  ],
) {

  ensure_packages($packages)

  file{ 'slurmd folder':
    ensure => directory,
    path   => $slurmd_folder,
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
  }

  file{ 'slurmd log':
    ensure => file,
    path   => $slurmd_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  logrotate::file{ 'slurmd':
    log     => $slurmd_log,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }
}
