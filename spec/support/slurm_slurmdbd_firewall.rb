shared_examples 'slurm::slurmdbd::firewall' do
  let(:params) { context_params }

  it { should have_firewall_resource_count(1) }

  it do
    should contain_firewall('100 allow access to slurmdbd').with({
      :proto  => 'tcp',
      :dport  => '6819',
      :action => 'accept',
    })
  end

  context 'when manage_firewall => false' do
    let(:params) { context_params.merge({ :manage_firewall => false }) }
    it { should have_firewall_resource_count(0) }
    it { should_not contain_firewall('100 allow access to slurmdbd') }
  end
end