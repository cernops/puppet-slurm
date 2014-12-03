# Private class
class slurm::common::config {

  if $slurm::manage_slurm_conf {
    file { 'slurm.conf':
      ensure  => 'present',
      path    => $slurm::slurm_conf_path,
      content => template($slurm::slurm_conf_template),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { 'slurm-partitions.conf':
      ensure  => 'present',
      path    => $slurm::partition_conf_path,
      content => template($slurm::partitionlist_template),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    datacat { 'slurm-nodes.conf':
      ensure   => 'present',
      path     => $slurm::node_conf_path,
      template => 'slurm/slurm.conf/nodes.conf.erb',
      owner    => 'root',
      group    => 'root',
      mode     => '0644',
    }

    Datacat_fragment <<| tag == $slurm::slurm_nodelist_tag |>>

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
      content => template($slurm::cgroup_conf_template),
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
