require 'spec_helper'

describe 'slurm' do
  on_supported_os(supported_os: [
                    {
                      'operatingsystem'        => 'RedHat',
                      'operatingsystemrelease' => ['7'],
                    },
                  ]).each do |_os, os_facts|
    let(:facts) { os_facts }
    let(:param_override) { {} }
    let(:params) { param_override }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('slurm::client') }
    it { is_expected.not_to contain_class('slurm::slurmd') }
    it { is_expected.not_to contain_class('slurm::slurmctld') }
    it { is_expected.not_to contain_class('slurm::slurmdbd') }

    it_behaves_like 'slurm::client'

    context 'slurmd' do
      let(:param_override) { { client: false, slurmd: true } }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::client') }

      it_behaves_like 'slurm::slurmd'
    end

    context 'slurmctld' do
      let(:param_override) { { client: false, slurmctld: true } }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::client') }

      it_behaves_like 'slurm::slurmctld'
    end

    context 'slurmdbd' do
      let(:param_override) { { client: false, slurmdbd: true } }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::client') }

      it_behaves_like 'slurm::slurmdbd'
    end
  end
end
