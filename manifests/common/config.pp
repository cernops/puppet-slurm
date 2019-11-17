# Private class
class slurm::common::config {

  create_resources('slurm::spank', $slurm::spank_plugins)

  if $slurm::manage_slurm_conf {
    file { 'slurm.conf':
      ensure  => 'present',
      path    => $slurm::slurm_conf_path,
      content => $slurm::slurm_conf_content,
      source  => $slurm::slurm_conf_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    concat { 'slurm-partitions.conf':
      ensure => 'present',
      path   => $slurm::partition_conf_path,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
    concat::fragment { 'slurm-partitions.conf-header':
      target  => 'slurm-partitions.conf',
      content => "# File managed by Puppet - DO NOT EDIT\n",
      order   => '00',
    }
    if $slurm::partition_source {
      concat::fragment { 'slurm-partitions.conf-source':
        target => 'slurm-partitions.conf',
        source => $slurm::partition_source,
        order  => '01',
      }
    }
    $::slurm::partitions.each |$name, $partition| {
      slurm::partition { $name: * => $partition }
    }

    concat { 'slurm-nodes.conf':
      ensure => 'present',
      path   => $slurm::node_conf_path,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
    concat::fragment { 'slurm-nodes.conf-header':
      target  => 'slurm-nodes.conf',
      content => "# File managed by Puppet - DO NOT EDIT\n",
      order   => '00',
    }
    if $slurm::node_source {
      concat::fragment { 'slurm-nodes.conf-source':
        target => 'slurm-nodes.conf',
        source => $slurm::node_source,
        order  => '01',
      }
    }
    $::slurm::nodes.each |$name, $_node| {
      slurm::node { $name: * => $_node }
    }

    concat { 'slurm-topology.conf':
      ensure => 'present',
      path   => $slurm::topology_conf_path,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
    concat::fragment { 'slurm-topology.conf-header':
      target  => 'slurm-topology.conf',
      content => "# File managed by Puppet - DO NOT EDIT\n",
      order   => '00',
    }
    if $slurm::topology_source {
      concat::fragment { 'slurm-topology.conf-source':
        target => 'slurm-topology.conf',
        source => $slurm::topology_source,
        order  => '01',
      }
    }
    $::slurm::switches.each |$name, $switch| {
      slurm::switch { $name: * => $switch }
    }

    file { 'plugstack.conf.d':
      ensure  => 'directory',
      path    => $slurm::plugstack_conf_d_path,
      recurse => true,
      purge   => $slurm::purge_plugstack_conf_d,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { 'plugstack.conf':
      ensure  => 'file',
      path    => $slurm::plugstack_conf_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('slurm/spank/plugstack.conf.erb'),
    }

    file { 'slurm-cgroup.conf':
      ensure  => 'file',
      path    => $slurm::cgroup_conf_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $slurm::cgroup_conf_content,
      source  => $slurm::cgroup_conf_source,
    }
  }

  if $slurm::tuning_net_core_somaxconn {
    sysctl { 'net.core.somaxconn':
      ensure => 'present',
      value  => String($slurm::tuning_net_core_somaxconn),
    }
  }
}
