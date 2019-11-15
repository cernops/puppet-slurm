require 'spec_helper'
require 'facter/util/slurm'

describe 'slurm_thread_count_per_core Fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  it 'returns 1 test 1' do
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:physicalprocessorcount).and_return('2')
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:processorcount).and_return('8')
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:corecountpercpu).and_return('4')
    expect(Facter.fact(:slurm_thread_count_per_core).value).to eq(1)
  end

  it 'returns 1 test 2' do
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:physicalprocessorcount).and_return('4')
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:processorcount).and_return('32')
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:corecountpercpu).and_return('8')
    expect(Facter.fact(:slurm_thread_count_per_core).value).to eq(1)
  end
end
