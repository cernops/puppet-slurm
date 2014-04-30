require 'spec_helper'

describe 'threadcountpercore Fact' do
  
  before :each do
    Facter.clear
    Facter.collection.internal_loader.load(:processor)
    Facter.fact(:kernel).stubs(:value).returns("Linux")
    File.stubs(:exists?).with('/proc/cpuinfo').returns(true)
  end

  it "should return 2" do
    cpuinfo = cpuinfo_fixture_read('xeon_E52667v2_dualsocket_cpuinfo')
    File.stubs(:readlines).with("/proc/cpuinfo").returns(cpuinfo_fixture_readlines('xeon_E52667v2_dualsocket_cpuinfo'))
    Facter::Util::FileRead.stubs(:read).with('/proc/cpuinfo').returns(cpuinfo_fixture_read('xeon_E52667v2_dualsocket_cpuinfo'))
    Facter.fact(:physicalprocessorcount).stubs(:value).returns(2)
    Facter.fact(:processorcount).stubs(:value).returns(32)
    Facter.fact(:corecountpercpu).stubs(:value).returns(8)
    Facter.fact(:threadcountpercore).value.should == 2
  end

  it "should return 1" do
    cpuinfo = cpuinfo_fixture_read('xeon_E52667v2_dualsocket_cpuinfo')
    File.stubs(:readlines).with("/proc/cpuinfo").returns(cpuinfo_fixture_readlines('xeon_E52667v2_dualsocket_cpuinfo'))
    Facter::Util::FileRead.stubs(:read).with('/proc/cpuinfo').returns(cpuinfo_fixture_read('xeon_E52667v2_dualsocket_cpuinfo'))
    Facter.fact(:physicalprocessorcount).stubs(:value).returns(2)
    Facter.fact(:processorcount).stubs(:value).returns(8)
    Facter.fact(:corecountpercpu).stubs(:value).returns(4)
    Facter.fact(:threadcountpercore).value.should == 1
  end
end
