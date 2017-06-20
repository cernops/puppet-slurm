# slurm/headnode/setup.pp
#
# Creates folders/logfiles and installs packages specific to headnode
#
# @param slurmctld_spool_dir Fully qualified pathname of a directory into which the slurmctld daemon's state information and batch job script information are written
# @param state_save_location Fully qualified pathname of a directory into which the Slurm controller, slurmctld, saves its state
# @param slurmctld_log_file Fully qualified pathname of a file into which the slurmctld daemon's logs are written
# @param packages Packages to install
#
# version 20170602
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode::setup (
  String[1,default] $slurmctld_spool_dir = '/var/spool/slurmctld',
  String[1,default] $state_save_location = '/var/spool/slurmctld/slurm.state',
  String[1,default] $slurmctld_log_file = '/var/log/slurm/slurmctld.log',
  Array[String] $packages = [
    'slurm-auth-none',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-torque',
  ],
) {

  ensure_packages($packages)

  file{ 'slurmctld folder':
    ensure  => directory,
    path    => $slurmctld_spool_dir,
    group   => 'slurm',
    mode    => '1755',
    owner   => 'slurm',
    require => User['slurm'],
  }

  file{ 'slurmctld state folder':
    ensure  => directory,
    path    => $state_save_location,
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
