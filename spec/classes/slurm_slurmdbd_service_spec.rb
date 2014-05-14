require 'spec_helper'

describe 'slurm::slurmdbd::service' do
  let(:facts) { default_facts }

  it { should create_class('slurm::slurmdbd::service') }

  it do
    should contain_service('slurmdbd').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end
end
