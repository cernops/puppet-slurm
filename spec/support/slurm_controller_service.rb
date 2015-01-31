shared_examples_for 'slurm::controller::service' do
  it do
    should contain_service('slurmctld').with({
      :ensure     => 'running',
      :enable     => 'true',
      :name       => 'slurm',
      :hasstatus  => 'false',
      :hasrestart => 'true',
      :pattern    => 'slurmctld -f /etc/slurm/slurm.conf',
    })
  end
end
