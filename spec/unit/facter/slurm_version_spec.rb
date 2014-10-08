require 'spec_helper'

describe 'slurm_version fact' do
  before :each do
    Facter::Util::Resolution.stubs(:which).with("sinfo").returns("/usr/bin/sinfo")
    Facter.clear
  end

  it "should return 14.03.6" do
    Facter::Util::Resolution.stubs(:exec).with("sinfo -V 2>/dev/null").returns("slurm 14.03.6")
    Facter.fact(:slurm_version).value.should == "14.03.6"
  end

  it "should be nil if sinfo -V returns unexpected output" do
    Facter::Util::Resolution.stubs(:exec).with("sinfo -V 2>/dev/null").returns("foo")
    Facter.fact(:slurm_version).value.should == nil
  end

  it "should be nil if sinfo not found" do
    Facter::Util::Resolution.stubs(:which).with("sinfo").returns(nil)
    Facter.fact(:slurm_version).value.should == nil
  end
end
