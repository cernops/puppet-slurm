# == Class: slurm::params
#
class slurm::params {

  case $::osfamily {
    'RedHat': {
      # do nothing
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
