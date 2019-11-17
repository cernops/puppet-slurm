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
    let(:roles) { ['client'] }
    let(:params) { param_override.merge(roles: roles) }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('slurm::client') }
    it { is_expected.not_to contain_class('slurm::slurmd') }
    it { is_expected.not_to contain_class('slurm::slurmctld') }
    it { is_expected.not_to contain_class('slurm::slurmdbd') }
    it { is_expected.not_to contain_class('slurm::slurmdbd::db') }

    it_behaves_like 'slurm::client'

    context 'slurmd' do
      let(:roles) { ['slurmd'] }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::client') }
      it { is_expected.not_to contain_class('slurm::slurmdbd::db') }

      it_behaves_like 'slurm::slurmd'
    end

    context 'slurmctld' do
      let(:roles) { ['slurmctld'] }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('slurm::slurmctld') }
      it { is_expected.not_to contain_class('slurm::slurmd') }
      it { is_expected.not_to contain_class('slurm::slurmdbd') }
      it { is_expected.not_to contain_class('slurm::client') }
      it { is_expected.not_to contain_class('slurm::slurmdbd::db') }

      it_behaves_like 'slurm::slurmctld'
    end

    context 'slurmdbd' do
      let(:roles) { ['slurmdbd'] }

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
      let(:roles) { ['database'] }

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
