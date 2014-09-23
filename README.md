# puppet-slurm

Puppet module for SLURM client and server

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

The following environment variables can be used to modify the behavior of the beaker tests:

* *BEAKER_destroy* - Values are "yes" or "no" to prevent VMs from being destroyed after tests.  Defaults to **yes**.
* *SLURM\_BEAKER\_yumrepo\_baseurl* - **Required** URL to Yum repository containing SLURM RPMs.
* *SLURM\_BEAKER\_package\_version* - Version of SLURM to install.  Defaults to **14.03.6-1.el6**
* *PUPPET\_BEAKER\_package\_version* - Version of Puppet to install.  Defaults to **3.6.2-1**

Example of running beaker tests using an internal repository, and leaving VMs running after the tests.

    export BEAKER_destroy=no
    export SLURM_BEAKER_yumrepo_baseurl="http://yum.example.com/slurm/el/6/x86_64"
    bundle exec rake beaker

## TODO

* Manage slurm.conf JobComp* config options
* Move common parameters from "role" specific classes into Class[slurm]
* master - require NFS or somehow ensure NFS present before applying mount resource
* Update documentation
