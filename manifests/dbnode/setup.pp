# slurm/dbnode/setup.pp
#
# Creates folders/logfiles and installs packages specific to dbnode
#
# @param slurmdbd_log_file Fully qualified pathname of a file into which the slurmd data base daemon will log entries
# @param packages Packages to install
#
# version 20170327
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::setup (
  String $slurmdbd_log_file  = '/var/log/slurm/slurmdbd.log',
  Array $packages = [
    'slurm-plugins',
    'slurm-slurmdbd',
    'slurm-sql',
  ],
) {

  ensure_packages($packages)

  file{ 'slurmdbd log file':
    ensure => file,
    path   => $slurmdbd_log_file,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  logrotate::file{ 'slurmdbd':
    log     => $slurmdbd_log_file,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }
}
