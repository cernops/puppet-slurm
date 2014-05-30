require 'spec_helper'
require 'facter/util/file_read'

describe 'processor_siblings_count Fact' do
  before :each do
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns("Linux")
  end

  it "should return 4" do
    File.stubs(:exists?).with('/proc/cpuinfo').returns(true)
    Facter::Util::FileRead.stubs(:read).with('/proc/cpuinfo').returns(cpuinfo_fixture_read('xeon_E5420_dualsocket_cpuinfo'))
    Facter.fact(:processor_siblings_count).value.should == 4
  end

  it "should return 8" do
    File.stubs(:exists?).with('/proc/cpuinfo').returns(true)
    Facter::Util::FileRead.stubs(:read).with('/proc/cpuinfo').returns(cpuinfo_fixture_read('amd_opteron_6320_quadsocket_cpuinfo'))
    Facter.fact(:processor_siblings_count).value.should == 8
  end

  it "should return 1 as default siblings_count" do
    File.stubs(:exists?).with('/proc/cpuinfo').returns(true)
    Facter::Util::FileRead.stubs(:read).with('/proc/cpuinfo').returns('foobar')
    Facter.fact(:processor_siblings_count).value.should == 1
  end

  it "should be nil if /proc/cpuinfo does not exist" do
    File.stubs(:exists?).with('/proc/cpuinfo').returns(false)
    Facter.fact(:processor_siblings_count).value.should == nil
  end
end
