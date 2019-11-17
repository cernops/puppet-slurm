#
define slurm::down_node (
  String $down_nodes          = $name,
  Optional[String] $reason    = undef,
# TODO
#  Slurm::DownNodeState $state = 'UNKNOWN',
  Enum['DOWN','DRAIN','FAIL','FAILING','UNKNOWN'] $state = 'UNKNOWN',
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
