# @summary Manage SLURM node configuration
#
#
#
# @param node_name
# @param node_hostname
# @param node_addr
# @param boards
# @param core_spec_count
# @param cores_per_socket
# @param cpu_bind
# @param cpus
# @param cpu_spec_list
# @param feature
# @param gres
# @param mem_spec_limit
# @param port
# @param real_memory
# @param sockets
# @param sockets_per_board
# @param state
# @param threads_per_core
# @param tmp_disk
# @param tres_weights
# @param weight
# @param order
#
define slurm::node (
  $node_name        = $name,
  $node_hostname    = undef,
  $node_addr        = undef,
  $boards           = undef,
  $core_spec_count  = undef,
  $cores_per_socket = undef,
  $cpu_bind         = undef,
  $cpus             = undef,
  $cpu_spec_list    = undef,
  $feature          = undef,
  $gres             = undef,
  $mem_spec_limit   = undef,
  $port             = undef,
  $real_memory      = undef,
  $sockets          = undef,
  $sockets_per_board = undef,
  Slurm::NodeState $state = 'UNKNOWN',
  $threads_per_core = undef,
  Optional[Integer] $tmp_disk = undef,
  $tres_weights     = undef,
  Optional[Integer] $weight = undef,
  $order            = '50',
) {

  include ::slurm

  $conf_values = {
    'NodeName' => $node_name,
    'NodeHostname' => $node_hostname,
    'NodeAddr'  => $node_addr,
    'Boards'  => $boards,
    'CoreSpecCount' => $core_spec_count,
    'CoresPerSocket' => $cores_per_socket,
    'CpuBind' => $cpu_bind,
    'CPUs'  => $cpus,
    'CpuSpecList' => $cpu_spec_list,
    'Feature' => $feature,
    'Gres'  => $gres,
    'MemSpecLimit'  => $mem_spec_limit,
    'Port'  => $port,
    'RealMemory'  => $real_memory,
    'SocketsPerBoard' => $sockets_per_board,
    'State' => $state,
    'ThreadsPerCore'  => $threads_per_core,
    'TmpDisk' => $tmp_disk,
    'TRESWeights' => $tres_weights,
  }

  concat::fragment { "slurm-nodes.conf-${name}":
    target  => 'slurm-nodes.conf',
    content => template($::slurm::node_template),
    order   => $order,
  }

}
