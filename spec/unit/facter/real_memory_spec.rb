require 'spec_helper'

describe 'real_memory Fact' do
  
  before :each do
    Facter.clear
    Facter.collection.internal_loader.load(:memory)
    Facter.fact(:kernel).stubs(:value).returns("Linux")
  end

  it "should return 32000 for 32GB server" do
    File.stubs(:readlines).with('/proc/meminfo').returns(my_fixture_read('32gb'))
    Facter.fact(:memorysize_mb).stubs(:value).returns('32107.20')
    Facter.fact(:real_memory).value.should == 32000
  end

  it "should return 64000 for 64GB server" do
    File.stubs(:readlines).with('/proc/meminfo').returns(my_fixture_read('64gb'))
    Facter.fact(:memorysize_mb).stubs(:value).returns('64414.66')
    Facter.fact(:real_memory).value.should == 64000
  end
end
