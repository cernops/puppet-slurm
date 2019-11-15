# Private class
class slurm::controller::service {

  file { '/etc/sysconfig/slurmctld':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    content => template('slurm/sysconfig/slurmctld.erb'),
  }

  if ! empty($slurm::slurmctld_service_limits) {
    systemd::service_limits { 'slurmctld.service':
      limits          => $slurm::sslurmctld_service_limits,
      restart_service => false,
    }
  }

  service { 'slurmctld':
    ensure     => $slurm::slurmctld_service_ensure,
    enable     => $slurm::slurmctld_service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

  include ::systemd::systemctl::daemon_reload
  Class['systemd::systemctl::daemon_reload'] -> Service['slurmctld']
}
