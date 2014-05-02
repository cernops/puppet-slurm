shared_examples 'slurm::munge' do
  let(:params) { context_params }

  it { should contain_class('slurm::munge') }

  it do
    should contain_package('munge').with({
      :ensure   => 'present',
      :before   => 'File[/etc/munge/munge.key]',
      :require  => 'Yumrepo[epel]',
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
