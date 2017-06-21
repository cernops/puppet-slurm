# slurm/workernode/setup.pp
#
# Creates folders/logfiles and installs packages specific to workernode
#
# @param slurmd_spool_dir Fully qualified pathname of a directory into which the Slurm deamon, slurmd, saves its state
# @param slurmd_log_file Fully qualified pathname of a file into which the slurmd daemon's logs are written
# @param packages Packages to install
#
# version 20170621
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::setup (
  String[1,default] $slurmd_spool_dir = '/var/spool/slurmd',
  String[1,default] $slurmd_log_file = '/var/log/slurm/slurmd.log',
  Array[String] $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-torque',
  ],
) {

  ensure_packages($packages)

  file{ 'slurmd spool folder':
    ensure => directory,
    path   => $slurmd_spool_dir,
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
