shared_examples 'slurm::worker::firewall' do
  let(:params) { context_params }

  it do
    should contain_firewall('100 allow access to slurmd').with({
      :proto  => 'tcp',
      :dport  => '6818',
      :action => 'accept',
    })
  end

  context 'when manage_firewall => false' do
    let(:params) { context_params.merge({ :manage_firewall => false }) }
    it { should contain_class('slurm::worker::config').that_comes_before('Class[slurm::worker::service]') }
    it { should_not contain_class('slurm::worker::firewall') }
    it { should have_firewall_resource_count(0) }
    it { should_not contain_firewall('100 allow access to slurmd') }
  end
end
