#
# slurm/setup.pp
#   Creates the basic folders, user/group and security for SLURM, common to
#   headnodes and workernodes
#

class slurm::setup (
  $homefolder = '/usr/local/slurm',
  $slurm_gid  = '950',
  $slurm_uid  = '950',
  $key_priv   = 'slurmkey',
  $key_pub    = 'slurmcert',
) {

  group{ 'slurm':
    ensure => present,
    gid    => $slurm_gid,
    system => true,
  }

  file{ 'slurm home folder':
    ensure => directory,
    path   => $homefolder,
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
  }

  user{ 'slurm':
    ensure  => present,
    comment => 'SLURM workload manager',
    gid     => 'slurm',
    home    => $homefolder,
    require => [Group['slurm'],File['slurm home folder']],
    system  => true,
    uid     => $slurm_uid,
  }

  file{ 'credentials folder':
    ensure  => directory,
    path    => "${homefolder}/credentials",
    group   => 'slurm',
    mode    => '1755',
    owner   => 'slurm',
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
}
