shared_examples_for 'slurm::controller' do
  it { is_expected.to contain_class('munge').that_comes_before('Class[slurm::common::user]') }
  it { is_expected.to contain_class('slurm::common::user').that_comes_before('Class[slurm::common::install]') }
  it { is_expected.to contain_class('slurm::common::install').that_comes_before('Class[slurm::common::setup]') }
  it { is_expected.to contain_class('slurm::common::setup').that_comes_before('Class[slurm::common::config]') }
  it { is_expected.to contain_class('slurm::common::config').that_comes_before('Class[slurm::controller::config]') }
  it { is_expected.to contain_class('slurm::controller::config').that_comes_before('Class[slurm::controller::service]') }
  it { is_expected.to contain_class('slurm::controller::service') }

  it_behaves_like 'slurm::common::user'
  it_behaves_like 'slurm::common::install::rpm'
  it_behaves_like 'slurm::common::install::rpm-slurmctld'
  it_behaves_like 'slurm::common::setup'
  it_behaves_like 'slurm::common::config'
  it_behaves_like 'slurm::controller::config'
  it_behaves_like 'slurm::controller::service'

  it do
    is_expected.to contain_firewall('100 allow access to slurmctld').with(proto: 'tcp',
                                                                          dport: '6817',
                                                                          action: 'accept')
  end

  context 'when manage_firewall => false' do
    let(:params) { param_override.merge(manage_firewall: false) }

    it { is_expected.not_to contain_firewall('100 allow access to slurmctld') }
  end
end
