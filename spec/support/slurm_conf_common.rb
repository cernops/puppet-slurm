shared_examples 'slurm_conf_common' do
  let(:params) { context_params }

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

  it { should contain_file("#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common") }

  it do
    content = catalogue.resource('file', "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common").send(:parameters)[:content]
    config = content.split("\n").reject { |c| c =~ /(^#|^$)/ }
    config.should == [
      "AccountingStorageHost=slurm.example.com",
      "AccountingStoragePass=slurmdbd",
      "AccountingStoragePort=6819",
      "AccountingStorageType=accounting_storage/slurmdbd",
      "AccountingStorageUser=slurmdbd",
      "AccountingStoreJobComment=YES",
      "AuthType=auth/munge",
      "CacheGroups=0",
      "CheckpointType=checkpoint/none",
      "ClusterName=linux",
      "CompleteWait=0",
      "ControlAddr=slurm",
      "ControlMachine=slurm",
      "CryptoType=crypto/munge",
      "DefaultStorageHost=slurm.example.com",
      "DefaultStoragePass=slurmdbd",
      "DefaultStoragePort=6819",
      "DefaultStorageType=slurmdbd",
      "DefaultStorageUser=slurmdbd",
      "DisableRootJobs=NO",
      "EpilogMsgTime=2000",
      "FastSchedule=1",
      "FirstJobId=1",
      "GetEnvTimeout=2",
      "GroupUpdateForce=0",
      "GroupUpdateTime=600",
      "HealthCheckInterval=0",
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
      "SlurmdSpoolDir=/var/spool/slurm/slurmd",
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
  end

  context 'when config_override defined' do
    let :params do
      context_params.merge({
        :config_override => {
          'PreemptMode'   => 'SUSPEND,GANG',
          'PreemptType'   => 'preempt/partition_prio',
          'ProctrackType' => 'proctrack/linuxproc',
        }
      })
    end

    it "should override values" do
      verify_contents(catalogue, "#{facts[:concat_basedir]}/_etc_slurm_slurm.conf/fragments/1_slurm.conf-common", [
        'PreemptMode=SUSPEND,GANG',
        'PreemptType=preempt/partition_prio',
        'ProctrackType=proctrack/linuxproc',
      ])
    end
  end
end
