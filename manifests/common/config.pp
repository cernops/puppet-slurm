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

    file { 'slurm-partitions.conf':
      ensure  => 'present',
      path    => $slurm::partition_conf_path,
      content => $slurm::partitionlist_content,
      source  => $slurm::partitionlist_source,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    if $slurm::node_source {
      file { 'slurm-nodes.conf':
        ensure => 'present',
        path   => $slurm::node_conf_path,
        source => $slurm::node_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    } else {
      datacat { 'slurm-nodes.conf':
        ensure   => 'present',
        path     => $slurm::node_conf_path,
        template => 'slurm/slurm.conf/nodes.conf.erb',
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
      }

      Datacat_fragment <<| tag == $slurm::slurm_nodelist_tag |>>
    }

    file { 'plugstack.conf.d':
      ensure  => 'directory',
      path    => $slurm::plugstack_conf_d_path,
      recurse => true,
      purge   => $slurm::purge_plugstack_conf_d,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
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

    file { 'cgroup_allowed_devices_file.conf':
      ensure  => 'file',
      path    => $slurm::cgroup_allowed_devices_file_real,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($slurm::cgroup_allowed_devices_template),
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure => present,
    value  => '1024',
  }

}
