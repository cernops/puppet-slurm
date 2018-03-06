# slurm/setup.pp
#
# Creates the basic folders, user/group and security for SLURM, common to headnodes and workernodes.
#
# @param slurm_version Slurm version to install.
# @param slurm_gid Group id for slurm group.
# @param slurm_uid User id for slurm user.
# @param slurm_home_loc Location of SLURM's home folder.
# @param slurm_log_file Location of SLURM's log folder.
# @param slurm_plugstack_loc Location of SLURM's plugstack folder.
#
# version 20170829
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::setup (
  Integer[0] $slurm_gid = 950,
  Integer[0] $slurm_uid = 950,
  String $slurm_home_loc = '/usr/local/slurm',
  String $slurm_log_file = '/var/log/slurm',
  String $slurm_plugstack_loc = '/etc/slurm/plugstack.conf.d',
  Array[String] $slurm_packages = $slurm::params::slurm_packages,
) inherits slurm::params {

################################################################################
# SLURM
################################################################################

  ensure_packages($slurm::params::slurm_packages, {'ensure' => $slurm::params::slurm_version})

  group{ 'slurm':
    ensure => present,
    gid    => $slurm_gid,
    system => true,
  }
  user{ 'slurm':
    ensure  => present,
    comment => 'SLURM workload manager',
    gid     => 'slurm',
    require => Group['slurm'],
    system  => true,
    uid     => $slurm_uid,
  }
  file{ dirtree($slurm_home_loc, $slurm_home_loc) :
    ensure  => directory,
  }
  -> file{ 'slurm folder':
    ensure  => directory,
    path    => $slurm_home_loc,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }
  file{ dirtree($slurm_log_file, $slurm_log_file) :
    ensure  => directory,
  }
  -> file{ 'slurm log folder':
    ensure  => directory,
    path    => $slurm_log_file,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }
  file{ dirtree($slurm_plugstack_loc, $slurm_plugstack_loc) :
    ensure  => directory,
  }
  -> file{ 'slurm plugstack folder':
    ensure  => directory,
    path    => $slurm_plugstack_loc,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }
}
