# @api private
class slurm::common::install::rpm {

  if $slurm::repo_baseurl {
    $package_require = Yumrepo['slurm']
    yumrepo { 'slurm':
      descr           => 'RPMS for SLURM',
      baseurl         => $slurm::repo_baseurl,
      enabled         => '1',
      metadata_expire => '1',
      gpgcheck        => '0',
      priority        => '1',
    }
  } else {
    $package_require = undef
  }

  Package {
    ensure  => $slurm::version,
    require => $package_require,
    notify  => $slurm::service_notify,
  }

  if $slurm::slurmd or $slurm::slurmctld or $slurm::client {
    package { 'slurm': }
    package { 'slurm-contribs': }
    package { 'slurm-devel': }
    package { 'slurm-example-configs': }
    package { 'slurm-perlapi': }
    package { 'slurm-libpmi': }
  }

  if $slurm::slurmd {
    package { 'slurm-slurmd': }
  }

  if $slurm::slurmctld {
    package { 'slurm-slurmctld': }
  }

  if $slurm::slurmdbd {
    package { 'slurm-slurmdbd': }
  }

  if $slurm::install_pam            { package { 'slurm-pam_slurm': } }
  if $slurm::install_torque_wrapper { package { 'slurm-torque': } }
}
