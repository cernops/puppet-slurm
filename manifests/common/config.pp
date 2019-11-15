# Private class
class slurm::common::config {

  create_resources('slurm::spank', $slurm::spank_plugins)

  if $slurm::manage_slurm_conf {
    file { 'slurm.conf':
      ensure  => 'present',
      path    => $slurm::slurm_conf_path,
      content => $slurm::slurm_conf_content,
      source  => $slurm::_slurm_conf_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { 'slurm-partitions.conf':
      ensure  => 'present',
      path    => $slurm::partition_conf_path,
      content => $slurm::partitionlist_content,
      source  => $slurm::_partitionlist_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    if $slurm::_node_source {
      file { 'slurm-nodes.conf':
        ensure => 'present',
        path   => $slurm::node_conf_path,
        source => $slurm::_node_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    } else {
      concat { 'slurm-nodes.conf':
        ensure => 'present',
        path   => $slurm::node_conf_path,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }

      Concat::Fragment <<| tag == $slurm::slurm_nodelist_tag |>>
    }

    # TODO: topology.conf

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
      source  => $slurm::_cgroup_conf_source,
    }
  }

  if $slurm::tuning_net_core_somaxconn {
    sysctl { 'net.core.somaxconn':
      ensure => 'present',
      value  => String($slurm::tuning_net_core_somaxconn),
    }
  }
}
