# @api private
class slurm::client {

  contain ::munge
  contain slurm::common::user
  contain slurm::common::install
  contain slurm::common::setup
  contain slurm::common::config

  Class['::munge']
  -> Class['slurm::common::user']
  -> Class['slurm::common::install']
  -> Class['slurm::common::setup']
  -> Class['slurm::common::config']

}
