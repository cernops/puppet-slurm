require 'spec_helper'

describe 'slurm' do
  on_supported_os({
    supported_os: [
      {
        'operatingsystem'        => 'RedHat',
        'operatingsystemrelease' => ['7'],
      }
    ],
  }).each do |os, os_facts|
    let(:facts) { os_facts }
    let(:param_override) { {} }
    let(:params) {  param_override }

    it 'requires a role' do
      expect { should compile }.to raise_error(/Must select a mode/)
    end

    context 'node' do
      let(:param_override) {{ node: true }}

      it { is_expected.to compile.with_all_deps }
      it { should contain_class('slurm::node') }
      it { should_not contain_class('slurm::controller') }
      it { should_not contain_class('slurm::slurmdbd') }
      it { should_not contain_class('slurm::client') }

      it_behaves_like 'slurm::node'
    end

    context 'controller' do
      let(:param_override) {{ :controller => true }}

      it { is_expected.to compile.with_all_deps }
      it { should contain_class('slurm::controller') }
      it { should_not contain_class('slurm::node') }
      it { should_not contain_class('slurm::slurmdbd') }
      it { should_not contain_class('slurm::client') }

      it_behaves_like 'slurm::controller'
    end

    context 'client' do
      let(:param_override) {{ :client => true }}

      it { is_expected.to compile.with_all_deps }
      it { should contain_class('slurm::client') }
      it { should_not contain_class('slurm::node') }
      it { should_not contain_class('slurm::controller') }
      it { should_not contain_class('slurm::slurmdbd') }

      it_behaves_like 'slurm::client'
    end

    context 'slurmdbd' do
      let(:param_override) {{ :slurmdbd => true }}

      it { is_expected.to compile.with_all_deps }
      it { should contain_class('slurm::slurmdbd') }
      it { should_not contain_class('slurm::node') }
      it { should_not contain_class('slurm::controller') }
      it { should_not contain_class('slurm::client') }

      it_behaves_like 'slurm::slurmdbd'
    end
  end
end
