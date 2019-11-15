shared_examples_for 'slurm::controller::config' do
  it do
    is_expected.to contain_file('/var/log/slurm').with(ensure: 'directory',
                                                       owner: 'slurm',
                                                       group: 'slurm',
                                                       mode: '0700')
  end

  it do
    is_expected.to contain_file('/var/run/slurm').with(ensure: 'directory',
                                                       owner: 'slurm',
                                                       group: 'slurm',
                                                       mode: '0700')
  end

  it do
    is_expected.to contain_file('/var/lib/slurm').with(ensure: 'directory',
                                                       owner: 'slurm',
                                                       group: 'slurm',
                                                       mode: '0700')
  end

  it do
    is_expected.to contain_file('StateSaveLocation').with(ensure: 'directory',
                                                          path: '/var/lib/slurm/state',
                                                          owner: 'slurm',
                                                          group: 'slurm',
                                                          mode: '0700',
                                                          require: 'File[/var/lib/slurm]')
  end

  it do
    is_expected.to contain_file('JobCheckpointDir').with(ensure: 'directory',
                                                         path: '/var/lib/slurm/checkpoint',
                                                         owner: 'slurm',
                                                         group: 'slurm',
                                                         mode: '0700',
                                                         require: 'File[/var/lib/slurm]')
  end

  it { is_expected.not_to contain_mount('StateSaveLocation') }
  it { is_expected.not_to contain_mount('JobCheckpointDir') }

  context 'when manage_state_dir_nfs_mount => true' do
    let(:params) { param_override.merge(manage_state_dir_nfs_mount: true) }

    it do
      is_expected.to contain_mount('StateSaveLocation').with(ensure: 'mounted',
                                                             name: '/var/lib/slurm/state',
                                                             atboot: 'true',
                                                             device: nil,
                                                             fstype: 'nfs',
                                                             options: 'rw,sync,noexec,nolock,auto',
                                                             require: 'File[StateSaveLocation]')
    end

    context 'when state_dir_nfs_device => "192.168.1.1:/slurm/state"' do
      let(:params) do
        param_override.merge(manage_state_dir_nfs_mount: true,
                             state_dir_nfs_device: '192.168.1.1:/slurm/state')
      end

      it { is_expected.to contain_mount('StateSaveLocation').with_device('192.168.1.1:/slurm/state') }
    end

    context 'when state_dir_nfs_options => "foo,bar"' do
      let(:params) do
        param_override.merge(manage_state_dir_nfs_mount: true,
                             state_dir_nfs_options: 'foo,bar')
      end

      it { is_expected.to contain_mount('StateSaveLocation').with_options('foo,bar') }
    end
  end

  context 'when manage_job_checkpoint_dir_nfs_mount => true' do
    let(:params) { param_override.merge(manage_job_checkpoint_dir_nfs_mount: true) }

    it do
      is_expected.to contain_mount('JobCheckpointDir').with(ensure: 'mounted',
                                                            name: '/var/lib/slurm/checkpoint',
                                                            atboot: 'true',
                                                            device: nil,
                                                            fstype: 'nfs',
                                                            options: 'rw,sync,noexec,nolock,auto',
                                                            require: 'File[JobCheckpointDir]')
    end

    context 'when job_checkpoint_dir_nfs_device => "192.168.1.1:/slurm/checkpoint"' do
      let(:params) do
        param_override.merge(manage_job_checkpoint_dir_nfs_mount: true,
                             job_checkpoint_dir_nfs_device: '192.168.1.1:/slurm/checkpoint')
      end

      it { is_expected.to contain_mount('JobCheckpointDir').with_device('192.168.1.1:/slurm/checkpoint') }
    end

    context 'when job_checkpoint_dir_nfs_options => "foo,bar"' do
      let(:params) do
        param_override.merge(manage_job_checkpoint_dir_nfs_mount: true,
                             job_checkpoint_dir_nfs_options: 'foo,bar')
      end

      it { is_expected.to contain_mount('JobCheckpointDir').with_options('foo,bar') }
    end
  end
end
