require 'spec_helper'
require 'facter/util/file_read'

describe 'threadcountpercore Fact' do
  before :each do
    Facter.clear
    Facter.collection.internal_loader.load(:processor)
    Facter.fact(:kernel).stubs(:value).returns("Linux")
    File.stubs(:exists?).with('/proc/cpuinfo').returns(true)
  end

  it "should return 1" do
    cpuinfo = cpuinfo_fixture_read('xeon_E5420_dualsocket_cpuinfo')
    File.stubs(:readlines).with("/proc/cpuinfo").returns(cpuinfo)
    Facter::Util::FileRead.stubs(:read).with('/proc/cpuinfo').returns(cpuinfo)
    Facter.fact(:physicalprocessorcount).stubs(:value).returns(2)
    Facter.fact(:processorcount).stubs(:value).returns(8)
    Facter.fact(:corecountpercpu).stubs(:value).returns(4)
    Facter.fact(:threadcountpercore).value.should == 1
  end

  it "should return 1" do
    cpuinfo = cpuinfo_fixture_read('amd_opteron_6320_quadsocket_cpuinfo')
    File.stubs(:readlines).with("/proc/cpuinfo").returns(cpuinfo)
    Facter::Util::FileRead.stubs(:read).with('/proc/cpuinfo').returns(cpuinfo)
    Facter.fact(:physicalprocessorcount).stubs(:value).returns(4)
    Facter.fact(:processorcount).stubs(:value).returns(32)
    Facter.fact(:corecountpercpu).stubs(:value).returns(8)
    Facter.fact(:threadcountpercore).value.should == 1
  end
end
