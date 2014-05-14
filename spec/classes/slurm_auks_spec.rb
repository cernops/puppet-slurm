require 'spec_helper'

describe 'slurm::auks' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::auks') }

  it { should contain_package('auks-slurm').with_ensure('present') }

  it do
    should contain_file('/etc/slurm/plugstack.conf.d/auks.conf').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
      :require => 'File[plugstack.conf.d]',
    })
  end

  context 'when auks_package_ensure => latest' do
    let(:pre_condition) { "class { 'slurm': auks_package_ensure => 'latest' }" }
    it { should contain_package('auks-slurm').with_ensure('latest') }
  end
end
