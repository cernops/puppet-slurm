shared_examples_for 'slurm::node::service' do
  it do
    should contain_service('slurmd').with({
      :ensure     => 'running',
      :enable     => 'true',
      :name       => 'slurm',
      :hasstatus  => 'false',
      :hasrestart => 'true',
      :pattern    => '/usr/sbin/slurmd -f',
    })
  end
end
