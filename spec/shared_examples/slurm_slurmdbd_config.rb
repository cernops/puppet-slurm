shared_examples_for 'slurm::slurmdbd::config' do
  it { is_expected.to contain_class('mysql::server') }

  it do
    is_expected.to contain_mysql__db('slurmdbd').with(user: 'slurmdbd',
                                                      password: 'slurmdbd',
                                                      host: 'localhost',
                                                      grant: ['ALL'])
  end

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
                                 'AuthType=auth/munge',
                                 "DbdHost=#{facts[:hostname]}",
                                 'DbdPort=6819',
                                 'DebugLevel=info',
                                 'LogFile=/var/log/slurm/slurmdbd.log',
                                 'MessageTimeout=10',
                                 'PidFile=/var/run/slurmdbd.pid',
                                 'PluginDir=/usr/lib64/slurm',
                                 'SlurmUser=slurm',
                                 'StorageHost=localhost',
                                 'StorageLoc=slurmdbd',
                                 'StoragePass=slurmdbd',
                                 'StoragePort=3306',
                                 'StorageType=accounting_storage/mysql',
                                 'StorageUser=slurmdbd',
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

  context 'when manage_logrotate => false' do
    let(:params) { param_override.merge(manage_logrotate: false) }

    it { is_expected.not_to contain_logrotate__rule('slurmdbd') }
  end

  context 'when use_remote_database => true' do
    let(:params) { param_override.merge(use_remote_database: true) }

    it { is_expected.not_to contain_class('mysql::server') }
    it { is_expected.not_to contain_mysql__db('slurmdbd') }
  end

  context 'when manage_database => false' do
    let(:params) { param_override.merge(manage_database: false) }

    it { is_expected.not_to contain_class('mysql::server') }
    it { is_expected.not_to contain_mysql__db('slurmdbd') }
  end

  context 'when use_syslog => true' do
    let(:params) { param_override.merge(use_syslog: true) }

    it do
      is_expected.to contain_file('slurmdbd.conf') \
        .without_content(%r{^LogFile.*$}) \
    end
  end
end
