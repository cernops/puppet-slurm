require 'spec_helper'
require 'facter/util/file_read'

describe 'slurm_processor_siblings_count Fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return("Linux")
    allow(File).to receive(:exists?).with('/proc/cpuinfo').and_return(true)
  end

  it "should return 4" do
    allow(Facter::Util::Slurm).to receive(:read_procfs).with('/proc/cpuinfo').and_return(cpuinfo_fixture_read('xeon_E5420_dualsocket_cpuinfo'))
    expect(Facter.fact(:slurm_processor_siblings_count).value).to eq(4)
  end

  it "should return 4" do
    allow(Facter::Util::Slurm).to receive(:read_procfs).with('/proc/cpuinfo').and_return(cpuinfo_fixture_read('amd_opteron_6320_quadsocket_cpuinfo'))
    expect(Facter.fact(:slurm_processor_siblings_count).value).to eq(8)
  end

  it "should return nil if can not parse" do
    allow(Facter::Util::Slurm).to receive(:read_procfs).with('/proc/cpuinfo').and_return('foobar')
    expect(Facter.fact(:slurm_processor_siblings_count).value).to be_nil
  end

  it "should be nil if /proc/cpuinfo does not exist" do
    allow(File).to receive(:exists?).with('/proc/cpuinfo').and_return(true)
    expect(Facter.fact(:slurm_processor_siblings_count).value).to be_nil
  end
end
