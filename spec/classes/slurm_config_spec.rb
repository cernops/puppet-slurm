require 'spec_helper'

describe 'slurm::config' do
  let(:facts) { default_facts }
  let(:params) {{ }}

  it { should create_class('slurm::config') }

  it do
    should contain_file('slurm CONFDIR').with({
      :ensure => 'directory',
      :path   => '/home/slurm/conf',
      :owner  => 'slurm',
      :group  => 'slurm',
      :mode   => '0755',
    })
  end

  it do
    should contain_file('/etc/sysconfig/slurm').with({
      :ensure  => 'file',
      :path    => '/etc/sysconfig/slurm',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/sysconfig/slurm', [
      'CONFDIR="/home/slurm/conf"',
      'SLURMCTLD_OPTIONS="-f /home/slurm/conf/slurm.conf"',
      'SLURMD_OPTIONS="-f /home/slurm/conf/slurm.conf"',
      'export SLURM_CONF="/home/slurm/conf/slurm.conf"',
    ])
  end

  it do
    should contain_file('/etc/profile.d/slurm.sh').with({
      :ensure  => 'file',
      :path    => '/etc/profile.d/slurm.sh',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/profile.d/slurm.sh', [
      'export SLURM_CONF="/home/slurm/conf/slurm.conf"',
    ])
  end

  it do
    should contain_file('/etc/profile.d/slurm.csh').with({
      :ensure  => 'file',
      :path    => '/etc/profile.d/slurm.csh',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/profile.d/slurm.csh', [
      'setenv SLURM_CONF="/home/slurm/conf/slurm.conf"',
    ])
  end

  it do
    should contain_concat('slurm.conf').with({
      :ensure   => 'present',
      :path     => '/home/slurm/conf/slurm.conf',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
      :require  => 'File[slurm CONFDIR]',
    })
  end

  it do
    should contain_concat__fragment('slurm.conf-common').with({
      :target => 'slurm.conf',
      :order  => '01',
    })
  end

  it do
    content = catalogue.resource('concat::fragment', "slurm.conf-common").send(:parameters)[:content]
    expected_lines = [
      "AccountingStorageHost=slurm",
      "AccountingStoragePort=6819",
      "AccountingStorageType=accounting_storage/slurmdbd",
      "AccountingStoreJobComment=YES",
      "AuthType=auth/munge",
      "CacheGroups=0",
      "CheckpointType=checkpoint/none",
      "ClusterName=linux",
      "CompleteWait=0",
      "ControlMachine=slurm",
      "CryptoType=crypto/munge",
      "DefaultStorageHost=slurm",
      "DefaultStoragePort=6819",
      "DefaultStorageType=slurmdbd",
      "DisableRootJobs=NO",
      "EpilogMsgTime=2000",
      "FastSchedule=1",
      "FirstJobId=1",
      "GetEnvTimeout=2",
      "GroupUpdateForce=0",
      "GroupUpdateTime=600",
      "HealthCheckInterval=0",
      "HealthCheckNodeState=ANY",
      "InactiveLimit=0",
      "JobAcctGatherFrequency=30",
      "JobAcctGatherType=jobacct_gather/linux",
      "JobCheckpointDir=/var/lib/slurm/checkpoint",
      "JobCompType=jobcomp/none",
      "JobRequeue=1",
      "KillOnBadExit=0",
      "KillWait=30",
      "MailProg=/bin/mail",
      "MaxJobCount=10000",
      "MaxJobId=4294901760",
      "MaxMemPerCPU=0",
      "MaxMemPerNode=0",
      "MaxStepCount=40000",
      "MaxTasksPerNode=128",
      "MessageTimeout=10",
      "MinJobAge=300",
      "MpiDefault=none",
      "OverTimeLimit=0",
      "PlugStackConfig=/home/slurm/conf/plugstack.conf",
      "PluginDir=/usr/lib64/slurm",
      "PreemptMode=OFF",
      "PreemptType=preempt/none",
      "PriorityType=priority/basic",
      "ProctrackType=proctrack/pgid",
      "PropagatePrioProcess=0",
      "PropagateResourceLimits=ALL",
      "ResvOverRun=0",
      "ReturnToService=0",
      "SchedulerTimeSlice=30",
      "SchedulerType=sched/builtin",
      "SelectType=select/linear",
      "SlurmSchedLogFile=/var/log/slurm/slurmsched.log",
      "SlurmSchedLogLevel=0",
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
      "SlurmdSpoolDir=/var/spool/slurmd",
      "SlurmdTimeout=300",
      "SlurmdUser=root",
      "StateSaveLocation=/var/lib/slurm/state",
      "SwitchType=switch/none",
      "TaskPlugin=task/none",
      "TmpFS=/tmp",
      "TopologyPlugin=topology/none",
      "TrackWCKey=no",
      "TreeWidth=50",
      "UsePAM=0",
      "VSizeFactor=0",
      "WaitTime=0",
    ]
    (content.split("\n") & expected_lines).should == expected_lines
  end

  it do
    should contain_concat__fragment('slurm.conf-partitions').with({
      :target => 'slurm.conf',
      :order  => '03',
    })
  end

  it do
    content = catalogue.resource('concat::fragment', "slurm.conf-partitions").send(:parameters)[:content]
    expected_lines = []
    (content.split("\n") & expected_lines).should == expected_lines
  end

  it do
    should contain_file('plugstack.conf.d').with({
      :ensure   => "directory",
      :path     => "/home/slurm/conf/plugstack.conf.d",
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0755',
      :require  => 'File[slurm CONFDIR]',
    })
  end

  it do
    should contain_file('plugstack.conf').with({
      :ensure   => 'file',
      :path     => '/home/slurm/conf/plugstack.conf',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
      :require  => 'File[slurm CONFDIR]',
    })
  end

  it do
    should contain_file('/etc/slurm/slurm.conf').only_with({
      :ensure   => 'link',
      :path     => '/etc/slurm/slurm.conf',
      :target   => '/home/slurm/conf/slurm.conf',
      :owner    => 'root',
      :group    => 'root',
    })
  end

  it do
    should contain_file('/etc/slurm/plugstack.conf.d').only_with({
      :ensure   => 'link',
      :path     => '/etc/slurm/plugstack.conf.d',
      :target   => '/home/slurm/conf/plugstack.conf.d',
      :owner    => 'root',
      :group    => 'root',
    })
  end

  it do
    should contain_file('/etc/slurm/plugstack.conf').only_with({
      :ensure   => 'link',
      :path     => '/etc/slurm/plugstack.conf',
      :target   => '/home/slurm/conf/plugstack.conf',
      :owner    => 'root',
      :group    => 'root',
    })
  end

  it do
    should contain_sysctl('net.core.somaxconn').with({
      :ensure => 'present',
      :value  => '1024',
    })
  end

  context 'when slurm_conf_override defined' do
    let :pre_condition do
      "class { 'slurm':
        slurm_conf_override => {
          'PreemptMode'   => 'SUSPEND,GANG',
          'PreemptType'   => 'preempt/partition_prio',
          'ProctrackType' => 'proctrack/linuxproc',
        }
      }"
    end

    it "should override values" do
      content = catalogue.resource('concat::fragment', "slurm.conf-common").send(:parameters)[:content]
      expected_lines = [
        'PreemptMode=SUSPEND,GANG',
        'PreemptType=preempt/partition_prio',
        'ProctrackType=proctrack/linuxproc',
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when partitionlist defined' do
    let :pre_condition do
      "class { 'slurm':
        partitionlist => [
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
      }"
    end

    it do
      content = catalogue.resource('concat::fragment', "slurm.conf-partitions").send(:parameters)[:content]
      expected_lines = [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=general Default=YES Priority=3 MaxNodes=1 MaxTime=48:00:00",
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when partitionlist_template defined' do
    let :pre_condition do
      "class { 'slurm': partitionlist_template => 'site_slurm/slurm.conf/partitions.erb' }"
    end

    it do
      content = catalogue.resource('concat::fragment', "slurm.conf-partitions").send(:parameters)[:content]
      expected_lines = [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context "partitionlist hierarchy - partitionlist_template first" do
    let :pre_condition do
      "class { 'slurm':
        partitionlist => [
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
        partitionlist_template => 'site_slurm/slurm.conf/partitions.erb',
      }"
    end

    it "slurm.conf-partitions should use partitionlist_content" do
      content = catalogue.resource('concat::fragment', "slurm.conf-partitions").send(:parameters)[:content]
      expected_lines = [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when epilog => /tmp/foo' do
    let(:pre_condition) { "class { 'slurm': epilog => '/tmp/foo' }" }

    it "should set the Epilog option" do
      content = catalogue.resource('concat::fragment', "slurm.conf-common").send(:parameters)[:content]
      expected_lines = [
        'Epilog=/tmp/foo',
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when health_check_program => /tmp/nhc' do
    let(:pre_condition) { "class { 'slurm': health_check_program => '/tmp/nhc' }" }

    it "should set the HealthCheckProgram option" do
      content = catalogue.resource('concat::fragment', "slurm.conf-common").send(:parameters)[:content]
      expected_lines = [
        'HealthCheckProgram=/tmp/nhc',
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when prolog => /tmp/bar' do
    let(:pre_condition) { "class { 'slurm': prolog => '/tmp/bar' }" }

    it "should set the Prolog option" do
      content = catalogue.resource('concat::fragment', "slurm.conf-common").send(:parameters)[:content]
      expected_lines = [
        'Prolog=/tmp/bar',
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when task_epilog => /tmp/epilog' do
    let(:pre_condition) { "class { 'slurm': task_epilog => '/tmp/epilog' }" }

    it "should set the TaskEpilog option" do
      content = catalogue.resource('concat::fragment', "slurm.conf-common").send(:parameters)[:content]
      expected_lines = [
        'TaskEpilog=/tmp/epilog',
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when task_prolog => /tmp/foobar' do
    let(:pre_condition) { "class { 'slurm': task_prolog => '/tmp/foobar' }" }

    it "should set the TaskProlog option" do
      content = catalogue.resource('concat::fragment', "slurm.conf-common").send(:parameters)[:content]
      expected_lines = [
        'TaskProlog=/tmp/foobar',
      ]
      (content.split("\n") & expected_lines).should == expected_lines
    end
  end

  context 'when slurm_conf_source defined' do
    let(:pre_condition) { "class { 'slurm': slurm_conf_source => 'puppet:///modules/site_slurm/slurm.conf'}" }

    it do
      should contain_file('slurm.conf').with({
        :ensure   => 'file',
        :path     => '/home/slurm/conf/slurm.conf',
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0644',
        :source   => 'puppet:///modules/site_slurm/slurm.conf',
        :require  => 'File[slurm CONFDIR]',
      })
    end

    it { should_not contain_concat('slurm.conf') }
    it { should_not contain_concat__fragment('slurm.conf-common') }
    it { should_not contain_concat__fragment('slurm.conf-partitions') }
  end

  context 'when manage_slurm_conf => false' do
    let(:params) {{ :manage_slurm_conf => false }}
    it { should_not contain_concat('slurm.conf') }
    it { should_not contain_concat__fragment('slurm.conf-common') }
    it { should_not contain_concat__fragment('slurm.conf-partitions') }
  end

  context 'when conf_dir => "/etc/slurm"' do
    let(:pre_condition) { "class { 'slurm': conf_dir => '/etc/slurm' }" }
    it { should_not contain_file('/etc/slurm/slurm.conf') }
    it { should_not contain_file('/etc/slurm/plugstack.conf.d') }
    it { should_not contain_file('/etc/slurm/plugstack.conf') }
  end
end
