shared_examples_for 'slurm::node::service' do
  it do
    should contain_service('slurm').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasstatus  => 'false',
      :hasrestart => 'true',
      :pattern    => '/usr/sbin/slurm(d|ctld) -f',
    })
  end
end
