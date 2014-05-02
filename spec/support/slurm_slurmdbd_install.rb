shared_examples 'slurm::slurmdbd::install' do
  let(:params) { context_params }

  # +1 for logrotate
  it { should have_package_resource_count(9) }

  it { should contain_package('slurm-slurmdbd').with_ensure('present') }

  context 'when slurm_package_ensure => "2.6.9"' do
    let(:params) { context_params.merge({ :slurm_package_ensure => '2.6.9' }) }

    it { should contain_package('slurm-slurmdbd').with_ensure('2.6.9') }
  end
end
