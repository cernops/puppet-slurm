shared_examples_for 'slurm::node::service' do
  it do
    should contain_service('slurmd').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end
end
