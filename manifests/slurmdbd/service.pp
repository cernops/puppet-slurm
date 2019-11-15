# Private class
class slurm::slurmdbd::service {

  file { '/etc/sysconfig/slurmdbd':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/sysconfig/slurmdbd.erb'),
  }

  if ! empty($slurm::slurmdbd_service_limits) {
    systemd::service_limits { 'slurmdbd.service':
      limits          => $slurm::sslurmdbd_service_limits,
      restart_service => false,
    }
  }

  service { 'slurmdbd':
    ensure     => $slurm::slurmdbd_service_ensure,
    enable     => $slurm::slurmdbd_service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

  include ::systemd::systemctl::daemon_reload
  Class['systemd::systemctl::daemon_reload'] -> Service['slurmdbd']
}
