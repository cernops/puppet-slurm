# infiniband_topology.rb from slurm module
#
# generate a yaml with the infiniband network topology
#
# version 20171113
#
# Copyright (c) CERN, 2016-2017
# Author: Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3
#
# The following script pipes ibnetdiscover into awk and outputs
# a YAML with a simplified topology.  Simplified means that even
# if the switch topology includes a full mesh of interconnected
# infiniband switches (such as common leaf-spine architectures),
# the resulting topology will only contain the leaf hosts and leaf
# switches, with an additional logical switch that connects the
# leaf switches together.

require 'yaml'

$ibtopology = <<SCRIPT
/usr/sbin/ibnetdiscover | /usr/bin/awk '
BEGIN {
        FS="[\\t \\\\[#\\":\\\\]]+"
        current_switch=0
}
{
        #Switch  36 "S-248a070300ce9c40"         # "MF0;U513-V-IB-L1-SW15:SX6036/U1" enhanced port 0 lid 2 lmc 0
        if ($1 ~ /^Switch/) {
                current_host=0
                current_switch++
                split($4, arr, "[:;]+") # $4 = "MF0;U513-V-IB-L2-SW14:SX6036/U1"
                switch_name = arr[2]
                switches[current_switch,0] = 0 # count number of hosts for switch
        }
        if ($0 ~ /^\\[[0-9]+/ && $3 ~ /^H-/) {
        #[5]     "H-ec0d9a030013cfb0"[1](ec0d9a030013cfb1)               # "p06850383a16176 HCA-1" lid 8 4xFDR
                current_host++
                host_name=$6
                switches[current_switch,current_host] = host_name
                switches[current_switch,0]++ # increase host count for this switch
        }
}
END {
        # We want to print only switches which have hosts connected as leafs
        # Output these switches enumerated starting at 1: S1..SN
        switch_num=1
        for (i=1; i<=current_switch; i++) {
                num_nodes = switches[i,0]
                if (num_nodes > 0) {
                        printf("-\\n  SwitchName: S%d\\n  Nodes: ", switch_num)
                        switch_num++
                        for (j=1; j<num_nodes; j++) {
                                printf("%s,", switches[i,j])
                        }
                        printf("%s\\n", switches[i,num_nodes])
                }
        }
        # Finally, print a logical switch that connects all these switches together
        printf("-\\n  SwitchName: S%d\\n  Switches: S[1-%d]\\n", switch_num, switch_num-1)
}'
SCRIPT

Facter.add(:infiniband_topology) do
  setcode do
    if File.file?('/usr/sbin/ibnetdiscover')
      begin
        YAML.load(Facter::Core::Execution.execute($ibtopology))
      rescue
        {}
      end
    else
      {}
    end
  end
end
