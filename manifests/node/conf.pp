#
define slurm::node::conf (
  $node_name        = $name,
  $node_addr        = $facts['ipaddress'],
  $cpus             = $facts['processorcount'],
  $sockets          = 'UNSET',
  $cores_per_socket = 'UNSET',
  $threads_per_core = 'UNSET',
  $real_memory      = $facts['slurm_real_memory'],
  $tmp_disk         = '16000',
  $node_weight      = 'UNSET',
  $feature          = 'UNSET',
  $state            = 'UNKNOWN',
) {

  include ::slurm

  concat::fragment { "slurm.conf-node-${name}":
    target  => 'slurm-nodes.conf',
    content => template($::slurm::node_template),
    tag     => $::slurm::slurm_nodelist_tag,
  }

}
