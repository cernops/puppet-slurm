shared_examples_for 'slurm::slurmdbd::service' do
  it do
    is_expected.to contain_service('slurmdbd').with(ensure: 'running',
                                                    enable: 'true',
                                                    hasstatus: 'true',
                                                    hasrestart: 'true')
  end
end
