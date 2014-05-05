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
    File <<| name == 'slurm.conf-exported' |>>
  }

}
