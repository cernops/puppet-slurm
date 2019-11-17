#
define slurm::switch (
  $switch_name = $name,
  $switches = undef,
  $nodes = undef,
  $link_speed = undef,
  $order = '50',
) {

  if ! $nodes and ! $switches {
    fail("slurm::switch: Must define either nodes or switches")
  }

  include ::slurm

  $conf_values = {
    'SwitchName' => $switch_name,
    'Switches' => $switches,
    'Nodes' => $nodes,
    'LinkSpeed' => $link_speed,
  }

  concat::fragment { "slurm-topology.conf-${name}":
    target  => 'slurm-topology.conf',
    content => template($::slurm::switch_template),
    order   => $order,
  }

}
