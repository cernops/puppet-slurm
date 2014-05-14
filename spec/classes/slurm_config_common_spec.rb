require 'spec_helper'

describe 'slurm::config::common' do
  let(:params) {{ }}

  it { should create_class('slurm::config::common') }

  it do
    should contain_file('/var/log/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/run/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/lib/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end
end
