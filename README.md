# puppet-slurm

Puppet module for SLURM client and server

## TODO

* verify config defaults w/ 14.03 release of SLURM
* rspec test passing storage_* parameters
* Manage slurm.conf JobComp* config options
* master - require NFS or somehow ensure NFS present before applying mount resource
* slurmdbd - unit test config file
* Slurmdbd - manage MySQL and other supported 'StorageType' values
* Add acceptance tests using beaker
* Notify Service resources when corresponding config changes
