require 'spec_helper'

describe 'slurm' do
  let(:facts) { default_facts }
  let(:params) {{ }}

  it { should create_class('slurm') }
  it { should contain_class('slurm::params') }

  # Test validate_bool parameters
  [
    'manage_slurm_user',
    'use_auks',
    'use_pam',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('slurm') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test validate_array parameters
  [
    'partitionlist',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p => 'foo' }}
      it { expect { should create_class('slurm') }.to raise_error(Puppet::Error, /is not an Array/) }
    end
  end

  # Test validate_hash parameters
  [
    'slurm_conf_override',
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) {{ p => 'foo' }}
      it { expect { should create_class('slurm') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end
end
