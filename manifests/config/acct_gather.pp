# slurm/config/acct_gather.pp
#
# Creates the acct_gather plugin configuration files.
#
# @param energy_ipmi_frequency This parameter is the number of seconds between BMC access samples.
# @param energy_ipmi_calc_adjustment If set to "yes", the consumption between the last BMC access sample and a step consumption update is approximated to get more accurate task consumption.
# @param energy_ipmi_power_sensors Optionally specify the ids of the sensors to used.
# @param energy_ipmi_username Specify BMC Username.
# @param energy_ipmi_password Specify BMC Password.
# @param profile_hdf5_dir This parameter is the path to the shared folder into which the acct_gather_profile plugin will write detailed data (usually as an HDF5 file).
# @param profile_hdf5_default A comma delimited list of data types to be collected for each job submission.
# @param interconnect_ofed_port This parameter represents the port number of the local Infiniband card that we are willing to monitor.
# @param profile_influxdb_host This parameter is mandatory when the influxdb plugin is setup and should contain information of the influxdb server in the following format: <hostname>:<port>
# @param profile_influxdb_db This parameter is mandatory when the influxdb plugin is setup. Database must already exist in the influxdb server.
# @param profile_influxdb_default A comma delimited list of data types to be collected for each job submission. 
# @param profile_influxdb_rtpolicy The InfluxDB retention policy name for the database configured in 'profile_influxdb_db' option.
# @param profile_influxdb_username Optinal InfluxDB username that should be used to gain access to the database configured with 'profile_influxdb_db'
# @param profile_influxdb_password Optional password for username configured with 'profile_influxdb_username'.
#
# version 20170816
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::config::acct_gather (
  String $ensure,
  Boolean $with_energy_ipmi = false,
  Integer[0] $energy_ipmi_frequency = 10,
  Enum['no','yes'] $energy_ipmi_calc_adjustment = 'no',
  Optional[Hash[String,String]] $energy_ipmi_power_sensors = undef,
  Optional[String] $energy_ipmi_username = undef,
  Optional[String] $energy_ipmi_password = undef,
  Boolean $with_profile_hdf5 = false,
  Optional[String] $profile_hdf5_dir = undef,
  String $profile_hdf5_default = 'None',
  Boolean $with_interconnect_ofed = false,
  Integer[0] $interconnect_ofed_port = 1,
  Boolean $with_profile_influxdb = false,
  Optional[String] $profile_influxdb_host = undef,
  Optional[String] $profile_influxdb_db = undef,
  String           $profile_influxdb_default = 'None',
  Optional[String] $profile_influxdb_rtpolicy = undef,
  Optional[String] $profile_influxdb_username = undef,
  Optional[String] $profile_influxdb_password = undef,
) {

  # AcctGather* plugin configuration
  file{'/etc/slurm/acct_gather.conf':
    ensure  => $ensure,
    content => template('slurm/acct_gather.conf.erb'),
    owner   => 'slurm',
    group   => 'slurm',
    mode    => '0644',
    require => User['slurm'],
  }
}
