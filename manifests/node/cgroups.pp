# Private class
class slurm::node::cgroups {

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

}
