shared_examples_for 'slurm::slurmd::config' do
  context 'when manage_scripts => false' do
    let(:params) { param_override.merge(manage_scripts: false) }

    it { is_expected.not_to contain_file('epilog') }
    it { is_expected.not_to contain_file('prolog') }
    it { is_expected.not_to contain_file('task_epilog') }
    it { is_expected.not_to contain_file('task_prolog') }
  end

  context 'when epilog => /tmp/foo' do
    let(:params) { param_override.merge(epilog: '/tmp/foo') }

    it 'sets the Epilog option' do
      verify_contents(catalogue, 'slurm.conf', [
                        'Epilog=/tmp/foo',
                      ])
    end

    it do
      is_expected.to contain_file('epilog').with(ensure: 'file',
                                                 path: '/tmp/foo',
                                                 source: nil,
                                                 owner: 'root',
                                                 group: 'root',
                                                 mode: '0755')
    end
  end

  context 'when epilog => /tmp/foo.d/*' do
    let(:params) { param_override.merge(epilog: '/tmp/foo.d/*') }

    it 'sets the Epilog option' do
      verify_contents(catalogue, 'slurm.conf', [
                        'Epilog=/tmp/foo.d/*',
                      ])
    end

    it do
      is_expected.to contain_file('epilog').with(ensure: 'directory',
                                                 path: '/tmp/foo.d',
                                                 source: nil,
                                                 owner: 'root',
                                                 group: 'root',
                                                 mode: '0755',
                                                 recurse: 'true',
                                                 recurselimit: '1',
                                                 purge: 'true')
    end
  end

  context 'when health_check_program => /usr/sbin/nhc' do
    let(:params) { param_override.merge(health_check_program: '/usr/sbin/nhc') }

    it 'sets the HealthCheckProgram option' do
      verify_contents(catalogue, 'slurm.conf', [
                        'HealthCheckProgram=/usr/sbin/nhc',
                      ])
    end
  end

  context 'when prolog => /tmp/bar' do
    let(:params) { param_override.merge(prolog: '/tmp/bar') }

    it 'sets the Prolog option' do
      verify_contents(catalogue, 'slurm.conf', [
                        'Prolog=/tmp/bar',
                      ])
    end

    it do
      is_expected.to contain_file('prolog').with(ensure: 'file',
                                                 path: '/tmp/bar',
                                                 source: nil,
                                                 owner: 'root',
                                                 group: 'root',
                                                 mode: '0755')
    end
  end

  context 'when prolog => /tmp/bar.d/*' do
    let(:params) { param_override.merge(prolog: '/tmp/bar.d/*') }

    it 'sets the Prolog option' do
      verify_contents(catalogue, 'slurm.conf', [
                        'Prolog=/tmp/bar.d/*',
                      ])
    end

    it do
      is_expected.to contain_file('prolog').with(ensure: 'directory',
                                                 path: '/tmp/bar.d',
                                                 source: nil,
                                                 owner: 'root',
                                                 group: 'root',
                                                 mode: '0755',
                                                 recurse: 'true',
                                                 recurselimit: '1',
                                                 purge: 'true')
    end
  end

  context 'when task_epilog => /tmp/epilog' do
    let(:params) { param_override.merge(task_epilog: '/tmp/epilog') }

    it 'sets the TaskEpilog option' do
      verify_contents(catalogue, 'slurm.conf', [
                        'TaskEpilog=/tmp/epilog',
                      ])
    end

    it do
      is_expected.to contain_file('task_epilog').with(ensure: 'file',
                                                      path: '/tmp/epilog',
                                                      source: nil,
                                                      owner: 'root',
                                                      group: 'root',
                                                      mode: '0755')
    end
  end

  context 'when task_prolog => /tmp/foobar' do
    let(:params) { param_override.merge(task_prolog: '/tmp/foobar') }

    it 'sets the TaskProlog option' do
      verify_contents(catalogue, 'slurm.conf', [
                        'TaskProlog=/tmp/foobar',
                      ])
    end

    it do
      is_expected.to contain_file('task_prolog').with(ensure: 'file',
                                                      path: '/tmp/foobar',
                                                      source: nil,
                                                      owner: 'root',
                                                      group: 'root',
                                                      mode: '0755')
    end
  end

  it do
    is_expected.to contain_file('SlurmdSpoolDir').with(ensure: 'directory',
                                                       path: '/var/spool/slurmd',
                                                       owner: 'root',
                                                       group: 'root',
                                                       mode: '0755')
  end

  it do
    is_expected.to contain_limits__limits('unlimited_memlock').with(ensure: 'present',
                                                                    user: '*',
                                                                    limit_type: 'memlock',
                                                                    hard: 'unlimited',
                                                                    soft: 'unlimited')
  end
end
