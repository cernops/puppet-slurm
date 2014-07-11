require 'spec_helper'

describe 'slurm::slurmdbd::install' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::slurmdbd::install') }
  it { should contain_class('slurm') }

  it { should have_package_resource_count(2) }

  it { should contain_package('slurm-slurmdbd').with_ensure('present').without_require }
  it { should contain_package('slurm-sql').with_ensure('present').without_require }

  context 'when ensure => "2.6.9"' do
    let(:params) {{ :ensure => '2.6.9-1.el6' }}

    it { should contain_package('slurm-slurmdbd').with_ensure('2.6.9-1.el6') }
    it { should contain_package('slurm-sql').with_ensure('2.6.9-1.el6') }
  end

  context 'when package_require => "Yumrepo[local]"' do
    let(:params) {{ :package_require => "Yumrepo[local]" }}

    it { should contain_package('slurm-slurmdbd').with_require('Yumrepo[local]') }
    it { should contain_package('slurm-sql').with_require('Yumrepo[local]') }
  end
end
