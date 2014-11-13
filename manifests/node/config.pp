# Private class
class slurm::node::config {

  if $slurm::manage_cgroup_release_agents {
    file { $slurm::cgroup_release_agent_dir_real:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }->
    file { "${slurm::cgroup_release_agent_dir_real}/release_common":
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => $slurm::cgroup_release_common_source_real,
    }->
    file { "${slurm::cgroup_release_agent_dir_real}/release_blkio":
      ensure => 'link',
      target => 'release_common',
    }->
    file { "${slurm::cgroup_release_agent_dir_real}/release_cpuacct":
      ensure => 'link',
      target => 'release_common',
    }->
    file { "${slurm::cgroup_release_agent_dir_real}/release_cpuset":
      ensure => 'link',
      target => 'release_common',
    }->
    file { "${slurm::cgroup_release_agent_dir_real}/release_freezer":
      ensure => 'link',
      target => 'release_common',
    }->
    file { "${slurm::cgroup_release_agent_dir_real}/release_memory":
      ensure => 'link',
      target => 'release_common',
    }->
    file { "${slurm::cgroup_release_agent_dir_real}/release_devices":
      ensure => 'link',
      target => 'release_common',
    }
  }

  file { $slurm::log_dir:
    ensure => 'directory',
    owner  => $slurm::slurmd_user,
    group  => $slurm::slurmd_user_group,
    mode   => '0700',
  }

  file { $slurm::pid_dir:
    ensure => 'directory',
    owner  => $slurm::slurmd_user,
    group  => $slurm::slurmd_user_group,
    mode   => '0700',
  }

  file { $slurm::shared_state_dir:
    ensure => 'directory',
    owner  => $slurm::slurmd_user,
    group  => $slurm::slurmd_user_group,
    mode   => '0700',
  }

  file { 'SlurmdSpoolDir':
    ensure => 'directory',
    path   => $slurm::slurmd_spool_dir,
    owner  => $slurm::slurmd_user,
    group  => $slurm::slurmd_user_group,
    mode   => '0755',
  }

  limits::limits { 'unlimited_memlock':
    ensure     => 'present',
    user       => '*',
    limit_type => 'memlock',
    hard       => 'unlimited',
    soft       => 'unlimited',
  }

  if $slurm::manage_logrotate {
    #Refer to: http://slurm.schedmd.com/slurm.conf.html#lbAJ
    logrotate::rule { 'slurmd':
      path          => $slurm::slurmd_log_file,
      compress      => true,
      missingok     => true,
      copytruncate  => false,
      delaycompress => false,
      ifempty       => false,
      rotate        => 10,
      sharedscripts => true,
      size          => '10M',
      create        => true,
      create_mode   => '0640',
      create_owner  => $slurm::slurmd_user,
      create_group  => 'root',
      postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    }
  }

}
