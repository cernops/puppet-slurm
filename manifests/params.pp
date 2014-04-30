# == Class: slurm::params
#
class slurm::params {

  case $::osfamily {
    'RedHat': {
      $package_runtime_dependencies = [
        'hwloc',
        'numactl',
        'libibmad',
        'freeipmi',
        'rrdtool',
        'gtk2',
      ]
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

}
