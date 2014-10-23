shared_examples_for 'slurm::client::service' do
  it do
    should contain_service('slurm').with({
      :ensure     => 'stopped',
      :enable     => 'false',
      :hasstatus  => 'false',
      :hasrestart => 'true',
      :pattern    => '/usr/sbin/slurm(d|ctld) -f',
    })
  end
end