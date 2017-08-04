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
# @param slurm_version Munge version to install; can be empty.
# @param munge_gid Group id for munge group.
# @param munge_uid User id for munge user.
# @param munge_loc Location of MUNGE's root folder.
# @param munge_log_file Location of MUNGE's log folder.
# @param munge_home_loc Location of MUNGE's home folder.
# @param munge_run_loc Location of MUNGE's run folder.
#
# version 20170804
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::setup (
  String[1,default] $slurm_version = '17.02.6',
  Integer[0,default] $slurm_gid = 950,
  Integer[0,default] $slurm_uid = 950,
  String[1,default] $slurm_home_loc = '/usr/local/slurm',
  String[1,default] $slurm_log_file = '/var/log/slurm',
  String[1,default] $slurm_plugstack_loc = '/etc/slurm/plugstack.conf.d',
  String[0,default] $munge_version = '0.5.11',
  Integer[0,default] $munge_gid = 951,
  Integer[0,default] $munge_uid = 951,
  String[1,default] $munge_loc = '/etc/munge',
  String[1,default] $munge_log_file = '/var/log/munge',
  String[1,default] $munge_home_loc = '/var/lib/munge',
  String[1,default] $munge_run_loc = '/run/munge',
) inherits slurm::config {

################################################################################
# SLURM
################################################################################

  $slurm_packages = [
    'slurm',
    'slurm-devel',
    'slurm-munge',
    'slurm-plugins',
  ]
  ensure_packages($slurm_packages, {'ensure' => $slurm_version})

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
  file{ 'slurm folder':
    ensure  => directory,
    path    => $slurm_home_loc,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }
  file{ 'slurm log folder':
    ensure  => directory,
    path    => $slurm_log_file,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }
  file{ 'slurm plugstack folder':
    ensure  => directory,
    path    => $slurm_plugstack_loc,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }

################################################################################
# MUNGE
#   only set up if MUNGE will be used as auth and/or crypto plugin
################################################################################
  if  ($slurm::config::auth_type == 'auth/munge') or
      ($slurm::config::crypto_type == 'crypto/munge') {

    $munge_packages = [
      'munge',
      'munge-libs',
      'munge-devel',
    ]
    ensure_packages($munge_packages, {'ensure' => $munge_version})

    group{ 'munge':
      ensure => present,
      gid    => $munge_gid,
      system => true,
    }
    user{ 'munge':
      ensure  => present,
      comment => 'Munge',
      home    => '/var/lib/munge',
      gid     => $munge_gid,
      require => Group['munge'],
      system  => true,
      uid     => $munge_uid,
    }
    file{ 'munge folder':
      ensure  => directory,
      path    => $munge_loc,
      owner   => 'munge',
      group   => 'munge',
      mode    => '1700',
      require => User['munge'],
    }
    file{ 'munge homedir':
      ensure  => directory,
      path    => $munge_home_loc,
      owner   => 'munge',
      group   => 'munge',
      mode    => '1700',
      require => User['munge'],
    }
    file{ 'munge log folder':
      ensure  => directory,
      path    => $munge_log_file,
      owner   => 'munge',
      group   => 'munge',
      mode    => '1700',
      require => User['munge'],
    }
    file{ 'munge run folder':
      ensure  => directory,
      path    => $munge_run_loc,
      owner   => 'munge',
      group   => 'munge',
      mode    => '1755',
      require => User['munge'],
    }
  }
}
