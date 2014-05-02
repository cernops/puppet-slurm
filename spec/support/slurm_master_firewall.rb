shared_examples 'slurm::master::firewall' do
  let(:params) { context_params }

  it { should have_firewall_resource_count(1) }

  it do
    should contain_firewall('100 allow access to slurmctld').with({
      :proto  => 'tcp',
      :dport  => '6817',
      :action => 'accept',
    })
  end

  context 'when manage_firewall => false' do
    let(:params) { context_params.merge({ :manage_firewall => false }) }
    it { should contain_class('slurm::master::config').that_comes_before('Class[slurm::master::service]') }
    it { should_not contain_class('slurm::master::firewall') }
    it { should have_firewall_resource_count(0) }
    it { should_not contain_firewall('100 allow access to slurmctld') }
  end
end
