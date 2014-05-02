shared_examples 'slurm::worker::service' do
  let(:params) { context_params }

  it { should have_service_resource_count(2) }

  it do
    should contain_service('slurm').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end
end
