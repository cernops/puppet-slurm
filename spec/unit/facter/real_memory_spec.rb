require 'spec_helper'

describe 'real_memory Fact' do
  before :each do
    Facter.clear
    Facter.collection.internal_loader.load(:memory)
    Facter.fact(:kernel).stubs(:value).returns("Linux")
  end

  it "should return 15900 for 16GB server" do
    File.stubs(:readlines).with('/proc/meminfo').returns(my_fixture_read('16gb'))
    Facter.fact(:memorysize_mb).stubs(:value).returns('15946.35')
    Facter.fact(:real_memory).value.should == 15900
  end

  it "should return 32100 for 32GB server" do
    File.stubs(:readlines).with('/proc/meminfo').returns(my_fixture_read('32gb'))
    Facter.fact(:memorysize_mb).stubs(:value).returns('32107.20')
    Facter.fact(:real_memory).value.should == 32100
  end

  it "should return 64400 for 64GB server" do
    File.stubs(:readlines).with('/proc/meminfo').returns(my_fixture_read('64gb'))
    Facter.fact(:memorysize_mb).stubs(:value).returns('64414.66')
    Facter.fact(:real_memory).value.should == 64400
  end

  it "should return 129000 for 128GB server" do
    File.stubs(:readlines).with('/proc/meminfo').returns(my_fixture_read('128gb'))
    Facter.fact(:memorysize_mb).stubs(:value).returns('129035.57')
    Facter.fact(:real_memory).value.should == 129000
  end
end
