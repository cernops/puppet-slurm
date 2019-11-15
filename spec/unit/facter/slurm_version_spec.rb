require 'spec_helper'

describe 'slurm_version fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  it 'returns 14.03.6' do
    allow(Facter::Util::Resolution).to receive(:which).with('sinfo').and_return('/usr/bin/sinfo')
    allow(Facter::Util::Resolution).to receive(:exec).with('/usr/bin/sinfo -V 2>/dev/null').and_return('slurm 19.05.3')
    expect(Facter.fact(:slurm_version).value).to eq('19.05.3')
  end

  it 'is nil if sinfo -V returns unexpected output' do
    allow(Facter::Util::Resolution).to receive(:which).with('sinfo').and_return('/usr/bin/sinfo')
    allow(Facter::Util::Resolution).to receive(:exec).with('/usr/bin/sinfo -V 2>/dev/null').and_return('')
  end

  it 'is nil if sinfo not present' do
    allow(Facter::Util::Resolution).to receive(:which).with('sinfo').and_return(nil)
    expect(Facter.fact(:slurm_version).value).to be_nil
  end
end
