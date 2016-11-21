#
# slurm/config.pp
#   creates the basic folders and user/group for SLURM common to headnodes and
#   workernodes
#

class slurm::config (
  $slurm_homefolder = '/var/lib/slurm',
  $slurm_gid        = '950',
  $slurm_uid        = '950',
) {

  file{ 'slurm home folder':
    ensure => directory,
    path   => $slurm_homefolder,
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
    home    => $slurm_homefolder,
    require => [Group['glexec'], File['slurm home folder']],
    system  => true,
    uid     => $slurm_uid,
  }
}
