class slurm::config {

  if ( $::osfamily != 'RedHat' ) {
    fail('This module is only tested on RedHat based machines')
  }

  group{'slurm':
    ensure  => present
  }

  user{'slurm':
    ensure  => present,
    uid     => $slurm::params::slurm_user_uid,
    gid     => 'slurm',
    shell   => '/bin/false',
    home    => '/home/slurm',
    require => Group['slurm']
  }

  file{'/var/log/slurm':
    ensure  => 'directory',
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0600',
  }

  file{'/etc/munge/munge.key.b64':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => hiera('slurm_munge_key_b64', 'cGxhY2Vob2xkZXI='),
    require => Package['munge']
  }

  exec{'munge-key-decoding':
    cwd         => "/etc/munge",
    path        => "/usr/bin",
    command     => "base64 -d munge.key.b64 > munge.key",
    subscribe   => File['/etc/munge/munge.key.b64'],
    notify      => File['/etc/munge/munge.key'],
    onlyif      => "test -f munge.key.b64",
    refreshonly => true
  }

  file{'/etc/munge/munge.key':
    ensure  => 'file',
    owner   => 'munge',
    group   => 'munge',
    mode    => '0400',
    notify  => Service['munge']
  }

  # High performance tweaks recommended in:
  #   https://computing.llnl.gov/linux/slurm/high_throughput.html
  augeas{'sysctl-tweaks':
    context => "/files/etc/sysctl.conf/",
    changes => [
      #"set net.ipv4.tcp_max_syn_backlog 1024", # remembered conn buf size
      "set net.core.somaxconn 1024", # socket.listen() backlog size
      # Not changed:
      #   - file-max: default values are higher
    ],
    notify => Exec['refresh-sysctl']
  }

  exec{'refresh-sysctl':
    cwd         => "/",
    path        => "/sbin",
    command     => "sysctl -p /etc/sysctl.conf &>/dev/null",
    subscribe   => Augeas['sysctl-tweaks'],
    refreshonly => true
  }

}
