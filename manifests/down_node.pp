# @summary Manage SLURM down node configuration
#
#
#
#
# @param down_nodes
# @param reason
# @param state
# @param order
#
define slurm::down_node (
  String $down_nodes          = $name,
  Optional[String] $reason    = undef,
  Slurm::DownNodeState $state = 'UNKNOWN',
  $order                      = '75',
) {

  include ::slurm

  $content = "DownNodes=${down_nodes} State=${state} Reason=\"${reason}\"\n"

  concat::fragment { "slurm-node.conf-${name}":
    target  => 'slurm-nodes.conf',
    content => $content,
    order   => $order,
  }

}
