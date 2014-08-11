# == Class: slurm::service
#
class slurm::service (
  $ensure = 'running',
  $enable = true,
  $manage_blcr = false,
  $blcr_ensure = 'running',
  $blcr_enable = true,
) {

  service { 'slurm':
    ensure      => $ensure,
    enable      => $enable,
    hasstatus   => false,
    hasrestart  => true,
    pattern     => '/usr/sbin/slurm(d|ctld) -f',
  }

  # TODO: Move to blcr module
  if $manage_blcr {
    service { 'blcr':
      ensure      => $blcr_ensure,
      enable      => $blcr_enable,
      hasstatus   => true,
      hasrestart  => true,
    }
  }

}
