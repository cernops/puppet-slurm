shared_examples 'slurm::worker::service' do
  let(:params) { context_params }

  it { should have_service_resource_count(2) }

  it do
    should contain_service('slurm').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'false',
      :hasrestart => 'true',
      :pattern    => '/usr/sbin/slurm(d|ctld)$',
    })
  end
end
