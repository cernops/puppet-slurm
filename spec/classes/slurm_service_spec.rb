require 'spec_helper'

describe 'slurm::service' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::service') }

  it do
    should contain_service('slurm').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'false',
      :hasrestart => 'true',
      :pattern    => '/usr/sbin/slurm(d|ctld) -f',
    })
  end

  it { should_not contain_service('blcr') }

  context 'when ensure => stopped' do
    let(:params) {{ :ensure => 'stopped' }}
    it { should contain_service('slurm').with_ensure('stopped') }
  end

  context 'when enable => false' do
    let(:params) {{ :enable => false }}
    it { should contain_service('slurm').with_enable('false') }
  end

  context 'when manage_blcr => true' do
    let(:params) {{ :manage_blcr => true }}

    it do
      should contain_service('blcr').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
      })
    end
  end
end
