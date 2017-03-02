# slurm/setup.pp
#
# Creates the basic folders, user/group and security for SLURM, common to
# headnodes and workernodes
#
# version 20170301
#
# @param slurm_home
# @param slurm_log
# @param slurm_gid
# @param slurm_uid
# @param slurm_key_priv
# @param slurm_key_pub
# @param munge_gid
# @param munge_uid
# @param munge_folder
# @param munge_log
# @param munge_home
# @param munge_run
# @param munge_key
# @param packages
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::setup (
  String $slurm_home     = '/usr/local/slurm',
  String $slurm_log      = '/var/log/slurm',
  Integer $slurm_gid     = 950,
  Integer $slurm_uid     = 950,
  String $slurm_key_priv = 'slurmkey',
  String $slurm_key_pub  = 'slurmcert',
  Integer $munge_gid     = 951,
  Integer $munge_uid     = 951,
  String $munge_folder   = '/etc/munge',
  String $munge_log      = '/var/log/munge',
  String $munge_home     = '/var/lib/munge',
  String $munge_run      = '/run/munge',
  String $munge_key      = 'mungekey',
  Array $packages = [
    'slurm',
    'slurm-devel',
    'slurm-munge',
    'munge',
    'munge-libs',
    'munge-devel',
  ],
) {

  ensure_packages($packages)

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
    path    => $slurm_home,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }
  file{ 'slurm log folder':
    ensure  => directory,
    path    => $slurm_log,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }

  file{ '/etc/slurm/plugstack.conf':
    ensure  => file,
    source  => 'puppet:///modules/slurm/plugstack.conf',
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }

  file{ '/etc/slurm/job_stuck_alert.sh':
    ensure  => file,
    source  => 'puppet:///modules/slurm/job_stuck_alert.sh',
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0755',
    require => User['slurm'],
  }

  file{ 'credentials folder':
    ensure  => directory,
    path    => "${slurm_home}/credentials",
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }
  teigi::secret{ 'slurm private key':
    key     => $slurm_key_priv,
    path    => "${slurm_home}/credentials/slurm.key",
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0400',
    require => File['credentials folder'],
  }
  teigi::secret{ 'slurm public key':
    key     => $slurm_key_pub,
    path    => "${slurm_home}/credentials/slurm.cert",
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0444',
    require => File['credentials folder'],
  }

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
    path    => $munge_folder,
    owner   => 'munge',
    group   => 'munge',
    mode    => '1700',
    require => User['munge'],
  }
  file{ 'munge homedir':
    ensure  => directory,
    path    => $munge_home,
    owner   => 'munge',
    group   => 'munge',
    mode    => '1700',
    require => User['munge'],
  }
  file{ 'munge log folder':
    ensure  => directory,
    path    => $munge_log,
    owner   => 'munge',
    group   => 'munge',
    mode    => '1700',
    require => User['munge'],
  }
  file{ 'munge run folder':
    ensure  => directory,
    path    => $munge_run,
    owner   => 'munge',
    group   => 'munge',
    mode    => '1755',
    require => User['munge'],
  }

  teigi::secret{ 'munge secret key':
    key     => $munge_key,
    path    => '/etc/munge/munge.key',
    owner   => 'munge',
    group   => 'munge',
    mode    => '0400',
    require => File['munge folder'],
  }
}
