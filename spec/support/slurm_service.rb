shared_examples 'slurm::service' do
  shared_context 'common' do

    let(:params) { context_params }

    it { should contain_class('slurm::service') }
  end

  shared_context 'worker and master' do
    let(:params) { context_params }

    include_context 'common'

    it { should have_service_resource_count(2) }

    it do
      should contain_service('slurm').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
      })
    end
  end

  shared_context 'slurmdb' do
    let(:params) { context_params }

    include_context 'common'

    it { should have_service_resource_count(1) }

    it do
      should contain_service('slurmdbd').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :require    => 'Class[Mysql::Server]',
      })
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

    include_context 'worker and master'
  end

  context 'when master only' do
    let :context_params do
      {
        :worker => false,
        :master => true,
        :slurmdb => false,
      }
    end

    include_context 'worker and master'
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
