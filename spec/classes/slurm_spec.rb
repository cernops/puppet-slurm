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
    let(:client) { true }
    let(:slurmd) { false }
    let(:slurmctld) { false }
    let(:slurmdbd) { false }
    let(:database) { false }
    let(:role_params) do
      {
        client: client,
        slurmd: slurmd,
        slurmctld: slurmctld,
        slurmdbd: slurmdbd,
        database: database
      }
    end
    let(:params) { param_override.merge(role_params) }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('slurm::client') }
    it { is_expected.not_to contain_class('slurm::slurmd') }
    it { is_expected.not_to contain_class('slurm::slurmctld') }
    it { is_expected.not_to contain_class('slurm::slurmdbd') }
    it { is_expected.not_to contain_class('slurm::slurmdbd::db') }

    it_behaves_like 'slurm::client'

    context 'slurmd' do
      let(:client) { false }
      let(:slurmd) { true }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::client') }
      it { is_expected.not_to contain_class('slurm::slurmdbd::db') }

      it_behaves_like 'slurm::slurmd'
    end

    context 'slurmctld' do
      let(:client) { false }
      let(:slurmctld) { true }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::client') }
      it { is_expected.not_to contain_class('slurm::slurmdbd::db') }

      it_behaves_like 'slurm::slurmctld'
    end

    context 'slurmdbd' do
      let(:client) { false }
      let(:slurmdbd) { true }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::client') }
      it { is_expected.not_to contain_class('slurm::slurmdbd::db') }

      it_behaves_like 'slurm::slurmdbd'
    end

    context 'database' do
      let(:pre_condition) { 'include ::mysql::server' }
      let(:client) { false }
      let(:database) { true }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmdbd::db') }
      it { is_expected.not_to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::client') }

      it_behaves_like 'slurm::slurmdbd::db'
    end
  end
end
