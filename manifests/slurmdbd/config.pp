# @api private
class slurm::slurmdbd::config {
  file { 'slurmdbd.conf':
    ensure  => 'file',
    path    => $slurm::slurmdbd_conf_path,
    owner   => $slurm::slurm_user,
    group   => $slurm::slurm_user_group,
    mode    => '0600',
    content => template('slurm/slurmdbd/slurmdbd.conf.erb'),
    notify  => Service['slurmdbd'],
  }
}
