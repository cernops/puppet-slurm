# slurm/config/cgroup.pp
#
# Creates the cgroup configuration files.
#
# @param cgroup_automount Slurm cgroup plugins require valid and functional cgroup subsystem to be mounted under /sys/fs/cgroup/<subsystem_name>. When launched, plugins check their subsystem availability. If not available, the plugin launch fails unless CgroupAutomount is set to yes. In that case, the plugin will first try to mount the required subsystems.
# @param cgroup_mountpoint Specify the PATH under which cgroups should be mounted. This should be a writable directory which will contain cgroups mounted one per subsystem.
# @param constrain_cores If configured to "yes" then constrain allowed cores to the subset of allocated resources.
# @param task_affinity If configured to "yes" then set a default task affinity to bind each step task to a subset of the allocated cores using sched_setaffinity.
# @param constrain_ram_space If configured to "yes" then constrain the job's RAM usage by setting the memory soft limit to the allocated memory and the hard limit to the allocated memory * AllowedRAMSpace.
# @param allowed_ram_space Constrain the job cgroup RAM to this percentage of the allocated memory.
# @param min_ram_space Set a lower bound (in MB) on the memory limits defined by AllowedRAMSpace and AllowedSwapSpace.
# @param max_ram_percent Set an upper bound in percent of total RAM on the RAM constraint for a job.
# @param constrain_swap_space If configured to "yes" then constrain the job's swap space usage.
# @param allowed_swap_space Constrain the job cgroup swap space to this percentage of the allocated memory.
# @param max_swap_percent Set an upper bound (in percent of total RAM) on the amount of RAM+Swap that may be used for a job.
# @param constrain_kmem_space If configured to "yes" then constrain the job's Kmem RAM usage. In addition to RAM usage. Only takes effect if ConstrainRAMSpace is set to "yes".
# @param allowed_kmem_space Constrain the job cgroup kernel memory to this percentage of the allocated memory.
# @param min_kmem_space Set a lower bound (in MB) on the memory limits defined by AllowedKmemSpace.
# @param max_kmem_percent Set an upper bound in percent of total Kmem for a job.
# @param constrain_devices If configured to "yes" then constrain the job's allowed devices based on GRES allocated resources.
# @param allowed_devices_file If the ConstrainDevices field is set to "yes" then this file has to be used to declare the devices that need to be allowed by default for all the jobs.
#
# version 20170816
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::config::cgroup (
  Enum['no','yes'] $cgroup_automount = 'no',
  String $cgroup_mountpoint = '/sys/fs/cgroup',
  Enum['no','yes'] $constrain_cores = 'no',
  Enum['no','yes'] $task_affinity = 'no',
  Enum['no','yes'] $constrain_ram_space = 'no',
  Float[0,100] $allowed_ram_space = 100.0,
  Integer[0] $min_ram_space = 30,
  Float[0,100] $max_ram_percent = 100.0,
  Enum['no','yes'] $constrain_swap_space = 'no',
  Float[0,100] $allowed_swap_space = 0.0,
  Float[0,100] $max_swap_percent = 100.0,
  Enum['no','yes'] $constrain_kmem_space = 'yes',
  Float[0,100] $allowed_kmem_space = 1.0,
  Integer[0] $min_kmem_space = 30,
  Float[0,100] $max_kmem_percent = 100.0,
  Enum['no','yes'] $constrain_devices = 'no',
  String $allowed_devices_file = '/etc/slurm/cgroup_allowed_devices_file.conf',
) {

  # Cgroup configuration
  file{ '/etc/slurm/cgroup.conf':
    ensure  => file,
    content => template('slurm/cgroup.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }
}
