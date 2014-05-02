shared_examples 'slurm::worker::install' do
  let(:params) { context_params }

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

  # +1 for logrotate
  it { should have_package_resource_count(10) }

  it { should contain_package('slurm').with_ensure('present') }
  it { should contain_package('slurm-munge').with_ensure('present') }

  context 'when use_auks => true' do
    let(:params) { context_params.merge({ :use_auks => true }) }
    it { should contain_package('auks-slurm').with_ensure('present') }
  end

  context 'when use_pam => true' do
    let(:params) { context_params.merge({ :use_pam => true }) }
    it { should contain_package('slurm-pam_slurm').with_ensure('present') }
  end

  context 'when slurm_package_ensure => "2.6.9"' do
    let(:params) { context_params.merge({ :slurm_package_ensure => '2.6.9' }) }

    it { should contain_package('slurm').with_ensure('2.6.9') }
    it { should contain_package('slurm-munge').with_ensure('2.6.9') }
  end
end
