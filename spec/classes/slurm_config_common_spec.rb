require 'spec_helper'

describe 'slurm::config::common' do
  let(:facts) { default_facts }
  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::config::common') }

  it do
    should contain_file('/etc/slurm').with({
      :ensure => 'link',
      :target => '/home/slurm/conf',
      :before => 'File[slurm CONFDIR]',
    })
  end

  it do
    should contain_file('slurm CONFDIR').with({
      :ensure => 'directory',
      :path   => '/home/slurm/conf',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0755',
    })
  end

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

  context 'when conf_dir => "/etc/slurm"' do
    let(:pre_condition) { "class { 'slurm': conf_dir => '/etc/slurm' }" }
    it { should_not contain_file('/etc/slurm') }
  end
end
