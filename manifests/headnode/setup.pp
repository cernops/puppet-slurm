# slurm/headnode/setup.pp
#
# Creates folders/logfiles and installs packages specific to headnode
#
# @param slurmctld_loc
# @param slurm_state_loc
# @param slurmctld_log_file
# @param packages
#
# version 20170306
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode::setup (
  String $slurmctld_loc      = '/var/spool/slurmctld',
  String $slurm_state_loc    = '/var/spool/slurmctld/slurm.state',
  String $slurmctld_log_file = '/var/log/slurm/slurmctld.log',
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

  file{ 'slurmctld folder':
    ensure  => directory,
    path    => $slurmctld_loc,
    group   => 'slurm',
    mode    => '1755',
    owner   => 'slurm',
    require => User['slurm'],
  }

  file{ 'slurmctld state folder':
    ensure  => directory,
    path    => $slurm_state_loc,
    group   => 'slurm',
    mode    => '1755',
    owner   => 'slurm',
    require => File['slurmctld folder'],
  }

  file{ 'slurmctld log':
    ensure  => file,
    path    => $slurmctld_log_file,
    group   => 'slurm',
    mode    => '0600',
    owner   => 'slurm',
    require => User['slurm'],
  }

  logrotate::file{ 'slurmctld':
    log     => $slurmctld_log_file,
    options => ['weekly','copytruncate','rotate 26','compress'],
  }
}
