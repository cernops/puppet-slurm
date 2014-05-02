shared_examples 'slurm::slurmdbd::service' do
  let(:params) { context_params }

  it { should have_service_resource_count(2) }

  it do
    should contain_service('slurmdbd').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'true',
      :hasrestart => 'true',
      #:require    => 'Class[Mysql::Server]',
    })
  end
end
