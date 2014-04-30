shared_examples 'slurm::firewall' do
  shared_context 'common' do
    let(:params) { context_params }

    it { should contain_class('slurm::firewall') }
  end

  shared_context 'worker' do
    let(:params) { context_params }

    include_context 'common'

    it do
      should contain_firewall('100 allow access to slurmd').with({
        :proto  => 'tcp',
        :dport  => '6818',
        :action => 'accept',
      })
    end

    context 'when manage_firewall => false' do
      let(:params) { context_params.merge({ :manage_firewall => false }) }
      it { should have_firewall_resource_count(0) }
      it { should_not contain_firewall('100 allow access to slurmd') }
    end
  end

  shared_context 'master' do
    let(:params) { context_params }

    include_context 'common'

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
      it { should have_firewall_resource_count(0) }
      it { should_not contain_firewall('100 allow access to slurmctld') }
    end
  end

  shared_context 'slurmdb' do
    let(:params) { context_params }

    include_context 'common'

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

  context 'when worker only' do
    let :context_params do
      {
        :worker => true,
        :master => false,
        :slurmdb => false,
      }
    end

    include_context 'worker'
  end

  context 'when master only' do
    let :context_params do
      {
        :worker => false,
        :master => true,
        :slurmdb => false,
      }
    end

    include_context 'master'
  end

  context 'when slurmdb only' do
    let :context_params do
      {
        :worker => false,
        :master => false,
        :slurmdb => true,
      }
    end

    include_context 'slurmdb'
  end
end
