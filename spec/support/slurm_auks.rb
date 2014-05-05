shared_examples 'slurm::auks' do
  let(:params) { context_params }

  it { should_not contain_class('slurm::auks') }

  context 'when use_auks => true' do
    let(:params) { context_params.merge({ :use_auks => true }) }

    it { should contain_class('slurm::auks') }

    it { should contain_package('auks-slurm').with_ensure('present') }
    it { should contain_file('/etc/slurm/plugstack.conf.d').with_ensure('directory') }

    it do
      should contain_file('/etc/slurm/plugstack.conf').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
        :notify => 'Service[slurm]',
      })
    end

    #TODO: Test /etc/slurm/plugstack.conf content

    it do
      should contain_file('/etc/slurm/plugstack.conf.d/auks.conf').with({
        :ensure  => 'file',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0644',
        :require => 'File[/etc/slurm/plugstack.conf.d]',
        :notify  => 'Service[slurm]',
      })
    end

    context 'when auks_package_ensure => latest' do
      let(:params) { context_params.merge({ :use_auks => true, :auks_package_ensure => 'latest' }) }
      it { should contain_package('auks-slurm').with_ensure('latest') }
    end
  end
end
