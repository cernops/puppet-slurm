# == Class: slurm::client::config
#
class slurm::client::config {

  include slurm

  File {
    owner => $slurm::slurm_user,
    group => $slurm::slurm_user_group,
  }

  if $slurm::slurm_conf_source {
    file { '/etc/slurm/slurm.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => $slurm::slurm_conf_source,
      notify  => Service['slurm'],
    }
  } else {
    concat_build { 'slurm.conf': }

    file { '/etc/slurm/slurm.conf':
      owner   => 'root',
      group   => 'root',
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

}
