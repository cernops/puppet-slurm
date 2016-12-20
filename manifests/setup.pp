#
# slurm/setup.pp
#   Creates the basic folders, user/group and security for SLURM, common to
#   headnodes and workernodes
#

class slurm::setup (
  $slurm_home     = '/usr/local/slurm',
  $slurm_log      = '/var/log/slurm',
  $slurm_gid      = '950',
  $slurm_uid      = '950',
  $slurm_key_priv = 'slurmkey',
  $slurm_key_pub  = 'slurmcert',
  $munge_gid      = '951',
  $munge_uid      = '951',
  $munge_folder   = '/etc/munge',
  $munge_log      = '/var/log/munge',
  $munge_home     = '/var/lib/munge',
  $munge_run      = '/run/munge',
  $munge_key      = 'mungekey',
  $packages = [
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

  file{ '/var/spool/slurmctld/slurm.state/clustername':
    ensure  => file,
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
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
