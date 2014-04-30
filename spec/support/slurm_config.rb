shared_examples 'slurm::config' do
  shared_context 'common' do

    let(:params) { context_params }

    it { should contain_class('slurm::config') }

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

    it do
      should contain_group('slurm').with({
        :ensure => 'present',
        :gid    => nil,
      })
    end

    it do
      should contain_user('slurm').with({
        :ensure => 'present',
        :uid    => nil,
        :gid    => 'slurm',
        :shell  => '/bin/false',
        :home   => '/home/slurm',
        :comment  => 'SLURM User',
      })
    end

    it do
      should contain_concat('/etc/slurm/slurm.conf').with({
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
      })
    end

    it do
      should contain_concat__fragment('slurm.conf-common').with({
        :target => '/etc/slurm/slurm.conf',
        :order  => '1',
      })
    end

    it do
      should contain_concat__fragment('slurm.conf-partitions').with({
        :target => '/etc/slurm/slurm.conf',
        :order  => '3',
      })
    end

    it { should contain_file("#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common") }

    it do
      content = catalogue.resource('file', "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common").send(:parameters)[:content]
      config = content.split("\n").reject { |c| c =~ /(^#|^$)/ }
      config.should == [
        "AccountingStorageEnforce=associations,limits,safe",
        "AccountingStorageHost=slurm.example.com",
        "AccountingStoragePass=slurmdb",
        "AccountingStoragePort=6819",
        "AccountingStorageType=accounting_storage/slurmdbd",
        "AccountingStorageUser=slurmdb",
        "AuthType=auth/munge",
        "CacheGroups=0",
        "ClusterName=linux",
        "ControlMachine=slurm",
        "CryptoType=crypto/munge",
        "FastSchedule=1",
        "FirstJobId=1",
        "InactiveLimit=0",
        "JobAcctGatherFrequency=30",
        "JobAcctGatherType=jobacct_gather/linux",
        "JobCheckpointDir=/var/lib/slurm/checkpoint",
        "JobCompType=jobcomp/none",
        "KillWait=15",
        "MailProg=/usr/bin/Mail",
        "MaxJobCount=5000",
        "MinJobAge=300",
        "MpiDefault=none",
        "PluginDir=/usr/lib64/slurm",
        "PreemptMode=SUSPEND,GANG",
        "PreemptType=preempt/partition_prio",
        "PriorityDecayHalfLife=7-0",
        "PriorityType=priority/basic",
        "PriorityUsageResetPeriod=NONE",
        "ProctrackType=proctrack/linuxproc",
        "PropagateResourceLimits=NONE",
        "ReturnToService=0",
        "SchedulerType=sched/backfill",
        "SelectType=select/linear",
        "SelectTypeParameters=CR_Memory",
        "SlurmUser=slurm",
        "SlurmctldDebug=3",
        "SlurmctldLogFile=/var/log/slurm/slurmctld.log",
        "SlurmctldPidFile=/var/run/slurm/slurmctld.pid",
        "SlurmctldPort=6817",
        "SlurmctldTimeout=300",
        "SlurmdDebug=3",
        "SlurmdLogFile=/var/log/slurm/slurmd.log",
        "SlurmdPidFile=/var/run/slurm/slurmd.pid",
        "SlurmdPort=6818",
        "SlurmdSpoolDir=/var/spool/slurm/slurmd",
        "SlurmdTimeout=300",
        "StateSaveLocation=/var/lib/slurm/state",
        "SwitchType=switch/none",
        "TaskPlugin=task/none",
        "TaskPluginParam=None",
        "Waittime=0",
      ]
    end

    it { should contain_file("#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions") }

    it do
      should contain_sysctl('net.core.somaxconn').with({
        :ensure => 'present',
        :value  => '1024',
      })
    end

    context 'when partitionlist defined' do
      let(:params) { context_params.merge({
        :partitionlist => [
          {
            'PartitionName' => 'DEFAULT',
            'Nodes'         => 'c[0-9]',
            'State'         => 'UP',
          },
          {
            'PartitionName' => 'general',
            'Priority'      => '3',
            'MaxNodes'      => '1',
            'MaxTime'       => '48:00:00',
            'Default'       => 'YES',
          }
        ]
      })}

      it do
        content = catalogue.resource('file', "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions").send(:parameters)[:content]
        config = content.split("\n").reject { |c| c =~ /(^#|^$)/ }
        config.should == [
          "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
          "PartitionName=general Default=YES Priority=3 MaxNodes=1 MaxTime=48:00:00",
        ]
      end
    end

    context 'when partitionlist_content defined' do
      let(:params) { context_params.merge({ :partitionlist_content => 'site_slurm/slurm.conf/partitions.erb' }) }

      it do
        content = catalogue.resource('file', "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions").send(:parameters)[:content]
        config = content.split("\n").reject { |c| c =~ /(^#|^$)/ }
        config.should == [
          "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
          "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
        ]
      end
    end

    context 'when partitionlist_source defined' do
      let(:params) { context_params.merge({ :partitionlist_source => 'puppet:///modules/site_slurm/slurm.conf/partitions' }) }

      it do
        should contain_file("#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions").with({
          :source => 'puppet:///modules/site_slurm/slurm.conf/partitions',
        })
      end
    end

    context "partitionlist hierarchy - partitionlist_content first" do
      let :params do
        context_params.merge({
          :partitionlist => [
            {
              'PartitionName' => 'DEFAULT',
              'Nodes'         => 'c[0-9]',
              'State'         => 'UP',
            },
            {
              'PartitionName' => 'general',
              'Priority'      => '3',
              'MaxNodes'      => '1',
              'MaxTime'       => '48:00:00',
              'Default'       => 'YES',
            }
          ],
          :partitionlist_content => 'site_slurm/slurm.conf/partitions.erb',
          :partitionlist_source => 'puppet:///modules/site_slurm/slurm.conf/partitions',
        })
      end

      it do
        should contain_concat__fragment('slurm.conf-partitions').with({
          :target => '/etc/slurm/slurm.conf',
          :source => nil,
          :order  => '3',
        })
      end

      it "slurm.conf-partitions should use partitionlist_content" do
        verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions", [
          "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
          "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
        ])
      end
    end

    context "partitionlist hierarchy - partitionlist_source second" do
      let :params do
        context_params.merge({
          :partitionlist => [
            {
              'PartitionName' => 'DEFAULT',
              'Nodes'         => 'c[0-9]',
              'State'         => 'UP',
            },
            {
              'PartitionName' => 'general',
              'Priority'      => '3',
              'MaxNodes'      => '1',
              'MaxTime'       => '48:00:00',
              'Default'       => 'YES',
            }
          ],
          :partitionlist_content => false,
          :partitionlist_source => 'puppet:///modules/site_slurm/slurm.conf/partitions',
        })
      end

      it do
        should contain_concat__fragment('slurm.conf-partitions').with({
          :target   => '/etc/slurm/slurm.conf',
          :content  => nil,
          :source   => 'puppet:///modules/site_slurm/slurm.conf/partitions',
          :order    => '3',
        })
      end
    end

    context "partitionlist hierarchy - partitionlist last" do
      let :params do
        context_params.merge({
          :partitionlist => [
            {
              'PartitionName' => 'DEFAULT',
              'Nodes'         => 'c[0-9]',
              'State'         => 'UP',
            },
            {
              'PartitionName' => 'general',
              'Priority'      => '3',
              'MaxNodes'      => '1',
              'MaxTime'       => '48:00:00',
              'Default'       => 'YES',
            }
          ],
          :partitionlist_content => false,
          :partitionlist_source => false,
        })
      end

      it do
        should contain_concat__fragment('slurm.conf-partitions').with({
          :target => '/etc/slurm/slurm.conf',
          :source => nil,
          :order  => '3',
        })
      end

      it "slurm.conf-partitions should use partitionlist_content" do
        verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/3_slurm.conf-partitions", [
          "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
          "PartitionName=general Default=YES Priority=3 MaxNodes=1 MaxTime=48:00:00",
        ])
      end
    end

    context 'when manage_group => false' do
      let(:params) { context_params.merge({ :manage_group => false }) }
      it { should_not contain_group('slurm') }
    end

    context 'when manage_user => false' do
      let(:params) { context_params.merge({ :manage_user => false }) }
      it { should_not contain_user('slurm') }
    end

    context 'when group_gid => 400' do
      let(:params) { context_params.merge({ :group_gid => 400 }) }
      it { should contain_group('slurm').with_gid('400') }
    end

    context 'when user_uid => 400' do
      let(:params) { context_params.merge({ :user_uid => 400 }) }
      it { should contain_user('slurm').with_uid('400') }
    end

    {
      'epilog' => '/home/slurm/epilog',
      'max_job_count' => '25000',
      'mpi_params' => 'ports=30000-39999',
      'prolog' => '/home/slurm/prolog',
      'select_type' => 'select/cons_res',
      'select_type_parameters' => 'CR_Core_Memory',
      'task_prolog' => '/home/slurm/taskprolog',
    }.each_pair do |k,v|
      context "#{k} => #{v}" do
        let(:params) { context_params.merge({ k => v }) }
        it do
          verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common", [
            "#{k.camel_case}=#{v}",
          ])
        end
      end
    end
  end

  shared_context 'slurm::config::worker' do
    let(:params) { context_params }

    include_context 'common'

    it { should contain_class('slurm::config') }
    it { should contain_class('slurm::config::worker') }
    it { should_not contain_class('slurm::config::master') }
    it { should_not contain_class('slurm::config::slurmdb') }

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
      should contain_file('/var/spool/slurm/slurmd').with({
        :ensure => 'directory',
        :owner  => 'slurm',
        :group  => 'slurm',
        :mode   => '0755',
      })
    end

    it { should_not contain_file('epilog') }
    it { should_not contain_file('prolog') }
    it { should_not contain_file('task_prolog') }

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
    end
  end

  shared_context 'slurm::config::master' do
    let(:params) { context_params }

    include_context 'common'

    it { should contain_class('slurm::config') }
    it { should contain_class('slurm::config::master') }
    it { should_not contain_class('slurm::config::worker') }
    it { should_not contain_class('slurm::config::slurmdb') }

    it do
      should contain_file('/var/lib/slurm/state').with({
        :ensure => 'directory',
        :owner  => 'slurm',
        :group  => 'slurm',
        :mode   => '0700',
      })
    end

    it do
      should contain_file('/var/lib/slurm/checkpoint').with({
        :ensure => 'directory',
        :owner  => 'slurm',
        :group  => 'slurm',
        :mode   => '0700',
      })
    end

    it do
      should contain_mount('/var/lib/slurm/state').with({
        :ensure   => 'mounted',
        :atboot   => 'true',
        :device   => nil,
        :fstype   => 'nfs',
        :options  => 'rw,sync,noexec,nolock,auto',
        :require  => 'File[/var/lib/slurm/state]',
      })
    end

    it do
      should contain_logrotate__rule('slurmctld').with({
        :path          => '/var/log/slurm/slurmctld.log',
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

    context 'when manage_logrotate => false' do
      let(:params) { context_params.merge({ :manage_logrotate => false }) }
      it { should_not contain_logrotate__rule('slurmctld') }
    end

    context 'when state_dir_nfs_device => "192.168.1.1:/slurm/state"' do
      let(:params) { context_params.merge({ :state_dir_nfs_device => "192.168.1.1:/slurm/state" }) }
      it { should contain_mount('/var/lib/slurm/state').with_device('192.168.1.1:/slurm/state') }
    end

    context 'when state_dir_nfs_options => "foo,bar"' do
      let(:params) { context_params.merge({ :state_dir_nfs_options => "foo,bar" }) }
      it { should contain_mount('/var/lib/slurm/state').with_options('foo,bar') }
    end

    context 'when state_dir_nfs_mount => false' do
      let(:params) { context_params.merge({ :state_dir_nfs_mount => false }) }
      it { should_not contain_mount('/var/lib/slurm/state') }
    end
  end

  shared_context 'slurm::config::slurmdb' do
    let(:params) { context_params }

    include_context 'common'

    it { should contain_class('slurm::config') }
    it { should contain_class('slurm::config::slurmdb') }
    it { should_not contain_class('slurm::config::worker') }
    it { should_not contain_class('slurm::config::master') }

    it do
      should contain_logrotate__rule('slurmdbd').with({
        :path          => '/var/log/slurm/slurmdbd.log',
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
        :postrotate    => '/etc/init.d/slurmdbd reconfig >/dev/null 2>&1',
      })
    end

    context 'when manage_logrotate => false' do
      let(:params) { context_params.merge({ :manage_logrotate => false }) }
      it { should_not contain_logrotate__rule('slurmdbd') }
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

    include_context 'slurm::config::worker'
  end

  context 'when master only' do
    let :context_params do
      {
        :worker => false,
        :master => true,
        :slurmdb => false,
      }
    end

    include_context 'slurm::config::master'
  end

  context 'when slurmdb only' do
    let :context_params do
      {
        :worker => false,
        :master => false,
        :slurmdb => true,
      }
    end

    include_context 'slurm::config::slurmdb'
  end
end
