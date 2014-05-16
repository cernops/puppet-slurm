# == Class: slurm::service
#
class slurm::service (
  $ensure = 'running',
  $enable = true,
) {

  service { 'slurm':
    ensure      => $ensure,
    enable      => $enable,
    hasstatus   => false,
    hasrestart  => true,
    pattern     => '/usr/sbin/slurm(d|ctld) -f',
  }

}
