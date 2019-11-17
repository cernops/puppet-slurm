shared_examples_for 'slurm::slurmd::service' do
  it do
    is_expected.to contain_service('slurmd').with(ensure: 'running',
                                                  enable: 'true',
                                                  hasstatus: 'true',
                                                  hasrestart: 'true')
  end
end
