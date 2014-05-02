shared_examples 'slurm::user' do
  let(:params) { context_params }

  it { should have_group_resource_count(1) }
  it { should have_user_resource_count(1) }

  it do
    should contain_group('slurm').with({
      :ensure => 'present',
      :name   => 'slurm',
      :gid    => nil,
    })
  end

  it do
    should contain_user('slurm').with({
      :ensure   => 'present',
      :name     => 'slurm',
      :uid      => nil,
      :gid      => 'slurm',
      :shell    => '/bin/false',
      :home     => '/home/slurm',
      :comment  => 'SLURM User',
    })
  end

  context 'when slurm_group_gid => 400' do
    let(:params) { context_params.merge({ :slurm_group_gid => 400 }) }

    it { should contain_group('slurm').with_gid('400') }
  end

  context 'when slurm_user_uid => 400' do
    let(:params) { context_params.merge({ :slurm_user_uid => 400 }) }

    it { should contain_user('slurm').with_uid('400') }
  end

  context 'when manage_slurm_user => false' do
    let(:params) { context_params.merge({ :manage_slurm_user => false }) }

    it { should have_group_resource_count(0) }
    it { should have_user_resource_count(0) }
    it { should_not contain_group('slurm') }
    it { should_not contain_user('slurm') }
  end
end
