#
# slurm/setup.pp
#   Creates the basic folders, user/group and security for SLURM, common to
#   headnodes and workernodes
#

class slurm::setup (
  $homefolder = '/usr/local/slurm',
  $munge_folder  = '/etc/munge',
  $munge_log     = '/var/log/munge',
  $slurm_gid  = '950',
  $slurm_uid  = '950',
  $munge_gid  = '951',
  $munge_uid  = '951',
  $key_priv   = 'slurmkey',
  $key_pub    = 'slurmcert',
  $munge_key  = 'mungekey',

  $packages = [
    'slurm-munge',
    'munge',
    'munge-libs',
    'munge-devel',
  ],
) {

  ensure_packages($packages)
  
  file{ 'munge folder':
    ensure => directory,
    path   => $munge_folder,
    group  => 'munge',
    mode   => '1700',
    owner  => 'munge',
  }

  file{ 'munge log folder':
    ensure => directory,
    path   => $munge_log,
    group  => 'munge',
    mode   => '1700',
    owner  => 'munge',
  }

  group{ 'munge':
    ensure => present,
    gid    => $munge_gid,
    system => true,
  }
  user{ 'munge':
    ensure  => present,
    comment => 'Munge',
    gid     => $munge_gid,
    require => Group['munge'],
    system  => true,
    uid     => $munge_uid,
  }

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
    path    => $homefolder,
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

  file{ 'credentials folder':
    ensure  => directory,
    path    => "${homefolder}/credentials",
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '1755',
    require => User['slurm'],
  }
  teigi::secret{ 'slurm private key':
    key     => $key_priv,
    path    => "${homefolder}/credentials/slurm.key",
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0400',
    require => File['credentials folder'],
  }
  teigi::secret{ 'slurm public key':
    key     => $key_pub,
    path    => "${homefolder}/credentials/slurm.cert",
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0444',
    require => File['credentials folder'],
  }
  #teigi::secret{ 'munge secret key':
  #  key     => $munge_key,
  #  path    => '/etc/munge/munge.key',
  #  owner   => 'munge',
  #  group   => 'munge',
  #  mode    => '0400',
  #  require => File['munge folder'],
  #}
}
