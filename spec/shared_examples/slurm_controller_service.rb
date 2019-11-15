shared_examples_for 'slurm::controller::service' do
  it do
    should contain_service('slurmctld').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end
end
