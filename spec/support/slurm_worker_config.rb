shared_examples 'slurm::worker::config' do
  let(:params) { context_params }

  it do
    should contain_file('/var/log/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/run/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/lib/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it do
    should contain_file('/var/spool/slurm').with({
      :ensure => 'directory',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it { should contain_file('/var/spool/slurm').that_comes_before('File[SlurmdSpoolDir]')}

  it do
    should contain_file('SlurmdSpoolDir').with({
      :ensure => 'directory',
      :path   => '/var/spool/slurm/slurmd',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0700',
    })
  end

  it { should_not contain_file('epilog') }
  it { should_not contain_file('health_check_program') }
  it { should_not contain_file('prolog') }
  it { should_not contain_file('task_epilog') }
  it { should_not contain_file('task_prolog') }

  it do
    should contain_concat__fragment("slurm.conf-nodelist_#{facts[:hostname]}").with({
      :tag    => 'slurm_nodelist',
      :target => '/etc/slurm/slurm.conf',
      :order  => '2',
    })
  end

  it { should contain_file("#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/2_slurm.conf-nodelist_#{facts[:hostname]}") }

  it do
    content = catalogue.resource('file', "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/2_slurm.conf-nodelist_#{facts[:hostname]}").send(:parameters)[:content]
    config = content.split("\n").reject { |c| c =~ /(^#|^$)/ }
    config.should == [
      "NodeName=#{facts[:hostname]} Sockets=2 CoresPerSocket=4 ThreadsPerCore=1 Procs=8 RealMemory=32000 TmpDisk=16000 State=UNKNOWN",
    ]
  end

  it do
    should contain_logrotate__rule('slurmd').with({
      :path          => '/var/log/slurm/slurmd.log',
      :compress      => 'true',
      :missingok     => 'true',
      :copytruncate  => 'false',
      :delaycompress => 'false',
      :ifempty       => 'false',
      :rotate        => '10',
      :sharedscripts => 'true',
      :size          => '10M',
      :create        => 'true',
      :create_mode   => '0640',
      :create_owner  => 'slurm',
      :create_group  => 'root',
      :postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    })
  end

  it do
    should contain_sysctl('net.core.somaxconn').with({
      :ensure => 'present',
      :value  => '1024',
    })
  end

  context 'when manage_logrotate => false' do
    let(:params) { context_params.merge({ :manage_logrotate => false }) }
    it { should_not contain_logrotate__rule('slurmd') }
  end

  context 'when epilog => /tmp/foo' do
    let(:params) { context_params.merge({ :epilog => '/tmp/foo' }) }

    it do
      should contain_file('epilog').with({
        :ensure => 'file',
        :path   => '/tmp/foo',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end

    it "should set the Epilog option" do
      verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common", [
        'Epilog=/tmp/foo',
      ])
    end
  end

  context 'when health_check_program => /tmp/nhc' do
    let(:params) { context_params.merge({ :health_check_program => '/tmp/nhc' }) }

    it do
      should contain_file('health_check_program').with({
        :ensure => 'file',
        :path   => '/tmp/nhc',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end

    it "should set the HealthCheckProgram option" do
      verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common", [
        'HealthCheckProgram=/tmp/nhc',
      ])
    end
  end

  context 'when prolog => /tmp/bar' do
    let(:params) { context_params.merge({ :prolog => '/tmp/bar' }) }

    it do
      should contain_file('prolog').with({
        :ensure => 'file',
        :path   => '/tmp/bar',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end

    it "should set the Prolog option" do
      verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common", [
        'Prolog=/tmp/bar',
      ])
    end
  end

  context 'when task_epilog => /tmp/epilog' do
    let(:params) { context_params.merge({ :task_epilog => '/tmp/epilog' }) }

    it do
      should contain_file('task_epilog').with({
        :ensure => 'file',
        :path   => '/tmp/epilog',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end

    it "should set the TaskEpilog option" do
      verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common", [
        'TaskEpilog=/tmp/epilog',
      ])
    end
  end

  context 'when task_prolog => /tmp/foobar' do
    let(:params) { context_params.merge({ :task_prolog => '/tmp/foobar' }) }

    it do
      should contain_file('task_prolog').with({
        :ensure => 'file',
        :path   => '/tmp/foobar',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end

    it "should set the TaskProlog option" do
      verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common", [
        'TaskProlog=/tmp/foobar',
      ])
    end
  end
end
