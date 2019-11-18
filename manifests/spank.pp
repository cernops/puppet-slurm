# @summary Manage SLURM SPANK plugin
#
# @param plugin
#   The shared library
# @param arguments
#   Arguments for the plugin
# @param required
#   Is this plugin required?
# @param config_path
#   Configuration path
# @param manage_package
#   Manage plugin package?
# @param package_name
#   Plugin package name
# @param restart_slurmd
#   Restart slurmd upon changes?
#
define slurm::spank (
  $plugin = "${title}.so",
  $arguments = {},
  $required = false,
  $config_path = undef,
  $manage_package = true,
  $package_name = "slurm-spank-${title}",
  $restart_slurmd = false,
) {

  include slurm

  validate_bool($required, $manage_package, $restart_slurmd)
  validate_hash($arguments)

  $config_path_real = pick($config_path, "${slurm::plugstack_conf_d_path}/${title}.conf")

  if $slurm::repo_baseurl {
    $package_require = Yumrepo['slurm']
  } else {
    $package_require = undef
  }

  if $restart_slurmd {
    $notify = Service['slurmd']
  } else {
    $notify = undef
  }

  if $manage_package {
    package { "SLURM SPANK ${title} package":
      ensure  => 'installed',
      name    => $package_name,
      before  => File["SLURM SPANK ${title} config"],
      notify  => $notify,
      require => $package_require,
    }
  }

  file { "SLURM SPANK ${title} config":
    ensure  => 'file',
    path    => $config_path_real,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/spank/plugin.conf.erb'),
    notify  => $notify,
  }

}
