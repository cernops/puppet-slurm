#
define slurm::node (
  $node_name        = $name,
  $node_hostname    = $facts['hostname'],
  $node_addr        = $facts['ipaddress'],
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
# TODO
#  Slurm::NodeState $state = 'UNKNOWN',
  Enum['CLOUD','FUTURE','DOWN','DRAIN','FAIL','FAILING','UNKNOWN'] $state = 'UNKNOWN',
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
