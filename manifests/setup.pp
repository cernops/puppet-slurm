# slurm/setup.pp
#
# Creates the basic folders, user/group and security for SLURM, common to
# headnodes and workernodes
#
# @param slurm_gid Group id for slurm group
# @param slurm_uid User id for slurm user
# @param slurm_home_loc Location of SLURM's home folder
# @param slurm_log_file Location of SLURM's log folder
# @param slurm_plugstack_loc Location of SLURM's plugstack folder
# @param munge_gid Group id for munge group
# @param munge_uid User id for munge user
# @param munge_loc Location of MUNGE's root folder
# @param munge_log_file Location of MUNGE's log folder
# @param munge_home_loc Location of MUNGE's home folder
# @param munge_run_loc Location of MUNGE's run folder
#
# version 20170505
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::setup (
  Integer $slurm_gid          = 950,
  Integer $slurm_uid          = 950,
  String $slurm_home_loc      = '/usr/local/slurm',
  String $slurm_log_file      = '/var/log/slurm',
  String $slurm_plugstack_loc = '/etc/slurm/plugstack.conf.d',
  Integer $munge_gid          = 951,
  Integer $munge_uid          = 951,
  String $munge_loc           = '/etc/munge',
  String $munge_log_file      = '/var/log/munge',
  String $munge_home_loc      = '/var/lib/munge',
  String $munge_run_loc       = '/run/munge',
) inherits slurm::config {

  # install MUNGE packages only if MUNGE will be used as auth and/or crypto plugin
  $slurm_packages = [
    'slurm',
    'slurm-devel',
    'slurm-munge',
  ]
  $munge_packages = [
    'munge',
    'munge-libs',
    'munge-devel',
  ]
  if  ($slurm::config::auth_type != 'auth/munge') and
      ($slurm::config::crypto_type != 'crypto/munge') {
    $packages = $slurm_packages
  }
  else {
    $packages = [$slurm_packages, $munge_packages]
  }

  ensure_packages($packages)

################################################################################
# SLURM
################################################################################
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

  # Stuck CG job alert
  file{ '/etc/slurm/job_stuck_alert.sh':
    ensure  => file,
    content => template('slurm/job_stuck_alert.sh.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }


################################################################################
# MUNGE
################################################################################
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
