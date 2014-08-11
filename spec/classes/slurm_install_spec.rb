require 'spec_helper'

describe 'slurm::install' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::install') }
  it { should contain_class('slurm') }

  it { should have_package_resource_count(4) }

  it { should contain_package('slurm').with_ensure('present').without_require }
  it { should contain_package('slurm-munge').with_ensure('present').without_require }
  it { should contain_package('slurm-plugins').with_ensure('present').without_require }
  it { should contain_package('slurm-torque').with_ensure('present').without_require }

  it { should_not contain_package('slurm-devel') }
  it { should_not contain_package('slurm-pam_slurm') }
  it { should_not contain_package('slurm-lua') }
  it { should_not contain_package('slurm-blcr') }
  it { should_not contain_package('blcr') }
  it { should_not contain_package('blcr-libs') }
  it { should_not contain_package('blcr-devel') }
  it { should_not contain_package('blcr-modules') }
  it { should_not contain_package('slurm-sjstat') }
  it { should_not contain_package('slurm-perlapi') }

  context 'when ensure => "2.6.9"' do
    let(:params) {{ :ensure => '2.6.9-1.el6' }}

    it { should contain_package('slurm').with_ensure('2.6.9-1.el6') }
    it { should contain_package('slurm-munge').with_ensure('2.6.9-1.el6') }
    it { should contain_package('slurm-plugins').with_ensure('2.6.9-1.el6') }
    it { should contain_package('slurm-torque').with_ensure('2.6.9-1.el6') }
  end

  context 'when package_require => "Yumrepo[local]"' do
    let(:params) {{ :package_require => "Yumrepo[local]" }}

    it { should contain_package('slurm').with_require('Yumrepo[local]') }
    it { should contain_package('slurm-munge').with_require('Yumrepo[local]') }
    it { should contain_package('slurm-plugins').with_require('Yumrepo[local]') }
    it { should contain_package('slurm-torque').with_require('Yumrepo[local]') }
  end

  context 'when use_pam => true' do
    let(:params) {{ :use_pam => true }}
    it { should contain_package('slurm-pam_slurm').with_ensure('present') }
  end

  context 'when with_devel => true' do
    let(:params) {{ :with_devel => true }}
    it { should contain_package('slurm-devel').with_ensure('present') }
  end

  context 'when install_torque_wrapper => false' do
    let(:params) {{ :install_torque_wrapper => false }}
    it { should_not contain_package('slurm-torque') }
  end

  context 'when install_tools => true' do
    let(:params) {{ :install_tools => true }}
    it { should contain_package('slurm-sjstat') }
    it { should contain_package('slurm-perlapi') }
  end

  context 'when with_lua => true' do
    let(:params) {{ :with_lua => true }}
    it { should contain_package('slurm-lua') }
  end

  context 'when with_blcr => true' do
    let(:params) {{ :with_blcr => true }}
    it { should contain_package('slurm-blcr') }
  end

  context 'when install_blcr => true' do
    let(:facts) { default_facts.merge({:kernelrelease => '2.6.32-431.23.3.el6.x86_64'}) }
    let(:params) {{ :install_blcr => true }}
    it { should contain_package('blcr') }
    it { should contain_package('blcr-libs') }
    it { should contain_package('blcr-devel') }
    it { should contain_package('blcr-modules').with_name('blcr-modules_2.6.32_431.23.3.el6.x86_64') }
  end
end
