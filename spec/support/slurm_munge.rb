shared_examples 'slurm::munge' do
  shared_context 'common' do

    let(:params) { context_params }

    it { should contain_class('slurm::munge') }

    it do
      should contain_package('munge').with({
        :ensure => 'present',
        :before => 'File[/etc/munge/munge.key]',
      })
    end

    it do
      should contain_file('/etc/munge/munge.key').with({
        :ensure => 'file',
        :owner  => 'munge',
        :group  => 'munge',
        :mode   => '0400',
        :source => nil,
        :before => 'Service[munge]',
      })
    end

    it do
      should contain_service('munge').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
      })
    end

    context 'when munge_package_ensure => latest' do
      let(:params) { context_params.merge({ :munge_package_ensure => 'latest' }) }
      it { should contain_package('munge').with_ensure('latest') }
    end
  end

  shared_context 'worker' do
    let(:params) { context_params }

    include_context 'common'
  end

  shared_context 'master' do
    let(:params) { context_params }

    include_context 'common'
  end

  shared_context 'slurmdb' do
    let(:params) { context_params }

    it { should_not contain_class('slurm::munge') }
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
