require 'spec_helper'
require 'facter/util/slurm'

describe 'real_memory Fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  it 'returns 15900 for 16GB server' do
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:memorysize_mb).and_return('15946.35')
    expect(Facter.fact(:slurm_real_memory).value).to eq(15_900)
  end

  it 'returns 32100 for 32GB server' do
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:memorysize_mb).and_return('32107.20')
    expect(Facter.fact(:slurm_real_memory).value).to eq(32_100)
  end

  it 'returns 64400 for 64GB server' do
    allow(Facter::Util::Slurm).to receive(:get_fact).with(:memorysize_mb).and_return('64414.66')
    expect(Facter.fact(:slurm_real_memory).value).to eq(64_400)
  end
end
