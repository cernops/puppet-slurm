shared_examples_for 'slurm::slurmctld::service' do
  it do
    is_expected.to contain_service('slurmctld').with(ensure: 'running',
                                                     enable: 'true',
                                                     hasstatus: 'true',
                                                     hasrestart: 'true')
  end
end
