def base_packages
  [
    'slurm',
    'slurm-devel',
    'slurm-munge',
    'slurm-perlapi',
    'slurm-plugins',
    'slurm-sjobexit',
    'slurm-sjstat',
    'slurm-torque',
  ]
end

def slurmdbd_packages
  [
    'slurm-slurmdbd',
    'slurm-sql',
  ]
end

shared_examples_for 'slurm::common::install' do

  base_packages.each do |p|
    it { should contain_package(p).with_ensure('present').without_require }
  end

  it { should_not contain_package('slurm-pam_slurm') }
  it { should_not contain_package('slurm-lua') }
  it { should_not contain_package('slurm-blcr') }

  context 'when version => "14.03.0-1.el6"' do
    let(:params) { default_params.merge({ :version => '14.03.0-1.el6' }) }

    base_packages.each do |p|
      it { should contain_package(p).with_ensure('14.03.0-1.el6').without_require }
    end
  end

  context 'when package_require => "Yumrepo[local]"' do
    let(:params) { default_params.merge({ :package_require => "Yumrepo[local]" }) }

    base_packages.each do |p|
      it { should contain_package(p).with_ensure('present').with_require('Yumrepo[local]') }
    end
  end

  context 'when install_pam => true' do
    let(:params) { default_params.merge({ :install_pam => true }) }
    it { should contain_package('slurm-pam_slurm').with_ensure('present') }
  end

  context 'when install_torque_wrapper => false' do
    let(:params) { default_params.merge({ :install_torque_wrapper => false }) }
    it { should_not contain_package('slurm-torque') }
  end

  context 'when install_lua => true' do
    let(:params) { default_params.merge({ :install_lua => true }) }
    it { should contain_package('slurm-lua') }
  end

  context 'when install_blcr => true' do
    let(:params) { default_params.merge({ :install_blcr => true }) }
    it { should contain_package('slurm-blcr') }
  end
end

shared_examples_for 'slurm::common::install-slurmdbd' do

  slurmdbd_packages.each do |p|
    it { should contain_package(p).with_ensure('present').without_require }
  end
end