shared_examples_for 'slurm::slurmdbd::config' do
  it do
    is_expected.to contain_file('slurmdbd.conf').with(ensure: 'file',
                                                      path: '/etc/slurm/slurmdbd.conf',
                                                      owner: 'slurm',
                                                      group: 'slurm',
                                                      mode: '0600',
                                                      notify: 'Service[slurmdbd]')
  end

  it do
    verify_exact_file_contents(catalogue, 'slurmdbd.conf', [
                                 'ArchiveDir=/tmp',
                                 'ArchiveEvents=no',
                                 'ArchiveJobs=no',
                                 'ArchiveResvs=no',
                                 'ArchiveSteps=no',
                                 'ArchiveSuspend=no',
                                 'ArchiveTXN=no',
                                 'ArchiveUsage=no',
                                 'AuthType=auth/munge',
                                 "DbdHost=slurmdbd",
                                 'DbdPort=6819',
                                 'DebugLevel=info',
                                 'LogFile=/var/log/slurm/slurmdbd.log',
                                 'LogTimeFormat=iso8601_ms',
                                 'MaxQueryTimeRange=INFINITE',
                                 'MessageTimeout=10',
                                 'PidFile=/var/run/slurmdbd.pid',
                                 'PluginDir=/usr/lib64/slurm',
                                 'SlurmUser=slurm',
                                 'StorageHost=localhost',
                                 'StorageLoc=slurm_acct_db',
                                 'StoragePass=slurmdbd',
                                 'StoragePort=3306',
                                 'StorageType=accounting_storage/mysql',
                                 'StorageUser=slurmdbd',
                                 'TCPTimeout=2',
                                 'TrackSlurmctldDown=no',
                               ])
  end

  context 'when slurmdbd_conf_override defined' do
    let(:params) do
      param_override.merge(slurmdbd_conf_override: { 'PrivateData' => 'users' })
    end

    it 'overrides values' do
      verify_contents(catalogue, 'slurmdbd.conf', ['PrivateData=users'])
    end
  end

  context 'when slurmdbd_storage_pass => "foobar"' do
    let(:params) { param_override.merge(slurmdbd_storage_pass: 'foobar') }

    it 'overrides values' do
      verify_contents(catalogue, 'slurmdbd.conf', ['StoragePass=foobar'])
    end
  end

  context 'when use_syslog => true' do
    let(:params) { param_override.merge(use_syslog: true) }

    it do
      is_expected.to contain_file('slurmdbd.conf') \
        .without_content(%r{^LogFile.*$}) \
    end
  end
end
