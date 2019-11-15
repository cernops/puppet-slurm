# Private class
class slurm::node::config {

  if $slurm::manage_scripts {
    if $slurm::manage_epilog and $slurm::epilog {
      if '*' in $slurm::epilog {
        file { 'epilog':
          ensure       => 'directory',
          path         => dirname($slurm::epilog),
          source       => $slurm::epilog_source,
          owner        => 'root',
          group        => 'root',
          mode         => '0755',
          recurse      => true,
          recurselimit => 1,
          purge        => true,
        }
      } else {
        file { 'epilog':
          ensure => 'file',
          path   => $slurm::epilog,
          source => $slurm::epilog_source,
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
    }

    if $slurm::manage_prolog and $slurm::prolog {
      if '*' in $slurm::prolog {
        file { 'prolog':
          ensure       => 'directory',
          path         => dirname($slurm::prolog),
          source       => $slurm::prolog_source,
          owner        => 'root',
          group        => 'root',
          mode         => '0755',
          recurse      => true,
          recurselimit => 1,
          purge        => true,
        }
      } else {
        file { 'prolog':
          ensure => 'file',
          path   => $slurm::prolog,
          source => $slurm::prolog_source,
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
    }

    if $slurm::manage_task_epilog and $slurm::task_epilog {
      file { 'task_epilog':
        ensure => 'file',
        path   => $slurm::task_epilog,
        source => $slurm::task_epilog_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }

    if $slurm::manage_task_prolog and $slurm::task_prolog {
      file { 'task_prolog':
        ensure => 'file',
        path   => $slurm::task_prolog,
        source => $slurm::task_prolog_source,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }
  }

  file { 'SlurmdSpoolDir':
    ensure => 'directory',
    path   => $slurm::slurmd_spool_dir,
    owner  => $slurm::slurmd_user,
    group  => $slurm::slurmd_user_group,
    mode   => '0755',
  }

  limits::limits { 'unlimited_memlock':
    ensure     => 'present',
    user       => '*',
    limit_type => 'memlock',
    hard       => 'unlimited',
    soft       => 'unlimited',
  }
}
