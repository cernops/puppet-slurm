#
# slurm/config.pp
#   creates the basic folders, user/group and security for SLURM, common to
#   headnodes and workernodes
#

class slurm::config (
  $homefolder = '/usr/local/slurm',
  $slurm_gid  = '950',
  $slurm_uid  = '950',
  $key_priv   = 'slurmkey',
  $key_pub    = 'slurmcert',
) {

  file{ 'slurm home folder':
    ensure => directory,
    path   => $homefolder,
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
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
    home    => $homefolder,
    require => [Group['glexec'], File['slurm home folder']],
    system  => true,
    uid     => $slurm_uid,
  }

  file{ 'credentials folder':
    ensure => directory,
    path   => "${homefolder}/credentials",
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
  }
  teigi::secret{ 'slurm private key':
    key     => 'slurmkey',
    path    => "${homefolder}/credentials/slurm.key",
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => File['credentials folder'],
  }
  teigi::secret{ 'slurm public key':
    key     => 'slurmcert',
    path    => "${homefolder}/credentials/slurm.cert",
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0600',
    require => File['credentials folder'],
  }
}
