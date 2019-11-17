# Private class
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
  }

  if ('slurmd' in $slurm::roles) or ('slurmctld' in $slurm::roles) or ('client' in $slurm::roles) {
    package { 'slurm': }
    package { 'slurm-contribs': }
    package { 'slurm-devel': }
    package { 'slurm-example-configs': }
    package { 'slurm-perlapi': }
    package { 'slurm-libpmi': }
    if $slurm::install_pam            { package { 'slurm-pam_slurm': } }
    if $slurm::install_torque_wrapper { package { 'slurm-torque': } }
  }

  if 'slurmd' in $slurm::roles {
    package { 'slurm-slurmd': }
  }

  if 'slurmctld' in $slurm::roles {
    package { 'slurm-slurmctld': }
  }

  if 'slurmdbd' in $slurm::roles {
    package { 'slurm-slurmdbd': }
  }
}
