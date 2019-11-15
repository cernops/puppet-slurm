shared_examples_for 'slurm::common::user' do
  it do
    should contain_group('slurm').with({
      :ensure     => 'present',
      :name       => 'slurm',
      :gid        => nil,
      :forcelocal => 'true',
    })
  end

  it do
    should contain_user('slurm').with({
      :ensure     => 'present',
      :name       => 'slurm',
      :uid        => nil,
      :gid        => 'slurm',
      :shell      => '/bin/false',
      :home       => '/home/slurm',
      :managehome => 'true',
      :comment    => 'SLURM User',
      :forcelocal => 'true',
    })
  end

  context 'when slurm_group_gid => 400' do
    let(:params) { param_override.merge({:slurm_group_gid => 400 }) }

    it { should contain_group('slurm').with_gid('400') }
  end

  context 'when slurm_user_uid => 400' do
    let(:params) { param_override.merge({:slurm_user_uid => 400 }) }

    it { should contain_user('slurm').with_uid('400') }
  end

  context 'when manage_slurm_user => false' do
    let(:params) { param_override.merge({:manage_slurm_user => false }) }

    it { should_not contain_group('slurm') }
    it { should_not contain_user('slurm') }
  end
end
