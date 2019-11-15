# Private class
class slurm::node::service {

  file { '/etc/sysconfig/slurmd':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/sysconfig/slurmd.erb'),
  }

  if ! empty($slurm::slurmd_service_limits) {
    systemd::service_limits { 'slurmd.service':
      limits          => $slurm::slurmd_service_limits,
      restart_service => false,
    }
  }

  service { 'slurmd':
    ensure     => $slurm::slurmd_service_ensure,
    enable     => $slurm::slurmd_service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

  include ::systemd::systemctl::daemon_reload
  Class['systemd::systemctl::daemon_reload'] -> Service['slurmd']
}
