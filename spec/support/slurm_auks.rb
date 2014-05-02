shared_examples 'slurm::auks' do
  let(:params) { context_params }

  it { should_not contain_class('slurm::auks') }

  context 'when use_auks => true' do
    let(:params) { context_params.merge({ :use_auks => true }) }

    it { should contain_class('slurm::auks') }

    it { should contain_package('auks-slurm').with_ensure('present') }

    context 'when auks_package_ensure => latest' do
      let(:params) { context_params.merge({ :use_auks => true, :auks_package_ensure => 'latest' }) }
      it { should contain_package('auks-slurm').with_ensure('latest') }
    end
  end
end
