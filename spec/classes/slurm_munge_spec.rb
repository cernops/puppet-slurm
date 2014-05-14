require 'spec_helper'

describe 'slurm::munge' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::munge') }
  it { should contain_class('slurm') }
  it { should contain_class('epel') }

  it do
    should contain_package('munge').with({
      :ensure   => 'present',
      :before   => 'File[/etc/munge/munge.key]',
      :require  => 'Yumrepo[epel]',
    })
  end

  it do
    should contain_file('/etc/munge/munge.key').with({
      :ensure => 'file',
      :owner  => 'munge',
      :group  => 'munge',
      :mode   => '0400',
      :source => nil,
      :before => 'Service[munge]',
    })
  end

  it do
    should contain_service('munge').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end

  context "when munge_key => 'puppet:///modules/site_slurm/munge.key'" do
    let(:pre_condition) { "class { 'slurm': munge_key => 'puppet:///modules/site_slurm/munge.key' }" }
    it { should contain_file('/etc/munge/munge.key').with_source('puppet:///modules/site_slurm/munge.key') }
  end

  context 'when munge_package_ensure => latest' do
    let(:pre_condition) { "class { 'slurm': munge_package_ensure => 'latest' }" }
    it { should contain_package('munge').with_ensure('latest') }
  end
end
