shared_examples 'slurm::install' do
  shared_context 'common' do
    package_runtime_dependencies = [
      'hwloc',
      'numactl',
      'libibmad',
      'freeipmi',
      'rrdtool',
      'gtk2',
    ]

    package_runtime_dependencies.each do |p|
      it { should contain_package(p).with_ensure('present') }
    end
  end

  shared_context 'worker and master' do
    let(:params) { context_params }

    include_context 'common'

    # +1 for logrotate
    it { should have_package_resource_count(12) }

    it { should contain_package('slurm').with_ensure('present') }
    it { should contain_package('slurm-plugins').with_ensure('present') }
    it { should contain_package('slurm-munge').with_ensure('present') }
    it { should contain_package('auks-slurm').with_ensure('present') }

    context 'when slurm_package_ensure => "2.6.9"' do
      let(:params) { context_params.merge({ :slurm_package_ensure => '2.6.9' }) }

      it { should contain_package('slurm').with_ensure('2.6.9') }
      it { should contain_package('slurm-plugins').with_ensure('2.6.9') }
      it { should contain_package('slurm-munge').with_ensure('2.6.9') }
    end
  end

  shared_context 'slurmdb' do
    let(:params) { context_params }

    include_context 'common'

    # +1 for logrotate
    it { should have_package_resource_count(9) }

    it { should contain_package('slurm-slurmdb').with_ensure('present') }
    it { should contain_package('slurm-sql').with_ensure('present') }

    context 'when slurm_package_ensure => "2.6.9"' do
      let(:params) { context_params.merge({ :slurm_package_ensure => '2.6.9' }) }

      it { should contain_package('slurm-slurmdb').with_ensure('2.6.9') }
      it { should contain_package('slurm-sql').with_ensure('2.6.9') }
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
