# puppet-slurm

Puppet module for SLURM client and server

## TODO

* Manage slurm.conf JobComp* config options
* Move common parameters from "role" specific classes into Class[slurm]
* master - require NFS or somehow ensure NFS present before applying mount resource
* Add acceptance tests using beaker
