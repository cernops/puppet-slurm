# slurm/dbnode/setup.pp
#
# Creates folders/logfiles and installs packages specific to dbnode
#
# version 20170301
#
# @param jobacct_log
# @param jobcomp_log
# @param slurmdbd_log
# @param packages
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::dbnode::setup (
  String $jobacct_log = '/var/log/slurm/slurm_jobacct.log',
  String $jobcomp_log = '/var/log/slurm/slurm_jobcomp.log',
  String $slurmdbd_log = '/var/log/slurm/slurmdbd.log',
  Array $packages = [
    'slurm-plugins',
    'slurm-slurmdbd',
    'slurm-sql',
  ],
) {

  ensure_packages($packages)

  file{ 'slurm job accounting log':
    ensure => file,
    path   => $jobacct_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  file{ 'slurm completed job log':
    ensure => file,
    path   => $jobcomp_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  file{ 'slurmdbd log file':
    ensure => file,
    path   => $slurmdbd_log,
    group  => 'slurm',
    mode   => '0600',
    owner  => 'slurm',
  }

  logrotate::file{ 'slurm_jobacct':
    log     => $jobacct_log,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }

  logrotate::file{ 'slurm_jobcomp':
    log     => $jobcomp_log,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }

  logrotate::file{ 'slurmdbd':
    log     => $slurmdbd_log,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }
}
