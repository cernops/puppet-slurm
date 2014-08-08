# == Class: slurm::params
#
class slurm::params {

  $cgroup_allowed_devices = [
    '/dev/null',
    '/dev/urandom',
    '/dev/zero',
    '/dev/sda*',
    '/dev/cpu/*/*',
    '/dev/pts/*',
  ]

  case $::osfamily {
    'RedHat': {
      # do nothing
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
