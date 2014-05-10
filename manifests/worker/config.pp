# == Class: slurm::worker::config
#
class slurm::worker::config {

  include slurm

  $procs = $::physicalprocessorcount*$::corecountpercpu*$::threadcountpercore

  File {
    owner => $slurm::slurmd_user,
    group => $slurm::slurmd_user_group,
  }

  file { 'SlurmdSpoolDir':
    ensure  => 'directory',
    path    => $slurm::slurmd_spool_dir,
    mode    => '0755',
  }

  if $slurm::epilog {
    file { 'epilog':
      ensure  => 'file',
      path    => $slurm::epilog,
      source  => $slurm::epilog_source,
      mode    => '0754',
    }
  }

  if $slurm::health_check_program {
    file { 'health_check_program':
      ensure  => 'file',
      path    => $slurm::health_check_program,
      source  => $slurm::health_check_program_source,
      mode    => '0754',
    }
  }

  if $slurm::prolog {
    file { 'prolog':
      ensure  => 'file',
      path    => $slurm::prolog,
      source  => $slurm::prolog_source,
      mode    => '0754',
    }
  }

  if $slurm::task_epilog {
    file { 'task_epilog':
      ensure  => 'file',
      path    => $slurm::task_epilog,
      source  => $slurm::task_epilog_source,
      mode    => '0754',
    }
  }

  if $slurm::task_prolog {
    file { 'task_prolog':
      ensure  => 'file',
      path    => $slurm::task_prolog,
      source  => $slurm::task_prolog_source,
      mode    => '0754',
    }
  }

  if $slurm::slurm_conf_source {
    file { '/etc/slurm/slurm.conf':
      ensure  => present,
      mode    => '0644',
      source  => $slurm::slurm_conf_source,
      notify  => Service['slurm'],
    }
  } else {
    concat_build { 'slurm.conf': }

    @@concat_fragment { "slurm.conf+02-node-${::hostname}":
      tag     => 'slurm_nodelist',
      content => template('slurm/slurm.conf/worker/slurm.conf.nodelist.erb'),
    }

    file { '/etc/slurm/slurm.conf':
      mode    => '0644',
      source  => concat_output('slurm.conf'),
      require => Concat_build['slurm.conf'],
      #notify  => Service['slurm'],
    }

    concat_fragment { 'slurm.conf+01-common':
      content => template($slurm::slurm_conf_template),
    }

    concat_fragment { 'slurm.conf+03-partitions':
      content => template($slurm::partitionlist_template),
    }

    Concat_fragment <<| tag == 'slurm_nodelist' |>>
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
      create_owner  => $slurm::slurm_user,
      create_group  => 'root',
      postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    }
  }

}
