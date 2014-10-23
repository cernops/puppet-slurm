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

    concat { 'slurm-nodes.conf':
      ensure         => 'present',
      path           => $slurm::node_conf_path,
      owner          => 'root',
      group          => 'root',
      mode           => '0644',
      ensure_newline => true,
    }

    Concat::Fragment <<| tag == $slurm::slurm_nodelist_tag |>>

    file { 'plugstack.conf.d':
      ensure => 'directory',
      path   => "${slurm::conf_dir}/plugstack.conf.d",
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    file { 'plugstack.conf':
      ensure  => 'file',
      path    => "${slurm::conf_dir}/plugstack.conf",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('slurm/plugstack.conf.erb'),
    }

    file { 'slurm-cgroup.conf':
      ensure  => 'file',
      path    => "${slurm::conf_dir}/cgroup.conf",
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

  if $slurm::manage_scripts {
    if $slurm::epilog {
      file { 'epilog':
        ensure => 'file',
        path   => $slurm::epilog,
        source => $slurm::epilog_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }

    if $slurm::health_check_program {
      file { 'health_check_program':
        ensure => 'file',
        path   => $slurm::health_check_program,
        source => $slurm::health_check_program_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }

    if $slurm::prolog {
      file { 'prolog':
        ensure => 'file',
        path   => $slurm::prolog,
        source => $slurm::prolog_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }

    if $slurm::task_epilog {
      file { 'task_epilog':
        ensure => 'file',
        path   => $slurm::task_epilog,
        source => $slurm::task_epilog_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }

    if $slurm::task_prolog {
      file { 'task_prolog':
        ensure => 'file',
        path   => $slurm::task_prolog,
        source => $slurm::task_prolog_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure => present,
    value  => '1024',
  }

}
