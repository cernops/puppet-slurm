shared_examples_for 'slurm::common::config' do
  it { is_expected.to have_slurm__spank_resource_count(0) }

  context 'with spank_plugins defined' do
    let(:param_override) { { spank_plugins: { 'x11' => {} } } }

    it { is_expected.to have_slurm__spank_resource_count(1) }
    it { is_expected.to contain_slurm__spank('x11') }
  end

  it do
    is_expected.to contain_file('slurm.conf').with(ensure: 'present',
                                                   path: '/etc/slurm/slurm.conf',
                                                   owner: 'root',
                                                   group: 'root',
                                                   mode: '0644')
  end

  it do
    verify_exact_file_contents(catalogue, 'slurm.conf', [
                                 'AccountingStorageHost=slurm',
                                 'AccountingStoragePort=6819',
                                 'AccountingStorageType=accounting_storage/slurmdbd',
                                 'AccountingStoreJobComment=YES',
                                 'AcctGatherNodeFreq=0',
                                 'AllowSpecResourcesUsage=0',
                                 'AuthType=auth/munge',
                                 'BatchStartTimeout=10',
                                 'CheckpointType=checkpoint/none',
                                 'ClusterName=linux',
                                 'CompleteWait=0',
                                 'CoreSpecPlugin=core_spec/none',
                                 'CpuFreqGovernors=OnDemand,Performance,UserSpace',
                                 'CredType=cred/munge',
                                 'DefaultStorageHost=slurm',
                                 'DefaultStoragePort=6819',
                                 'DisableRootJobs=NO',
                                 'EioTimeout=60',
                                 'EnforcePartLimits=NO',
                                 'EpilogMsgTime=2000',
                                 'FairShareDampeningFactor=1',
                                 'FirstJobId=1',
                                 'GetEnvTimeout=2',
                                 'GroupUpdateForce=1',
                                 'GroupUpdateTime=600',
                                 'GpuFreqDef=high,memory=high',
                                 'HealthCheckInterval=0',
                                 'HealthCheckNodeState=ANY',
                                 'InactiveLimit=0',
                                 'JobAcctGatherType=jobacct_gather/cgroup',
                                 'JobAcctGatherFrequency=task=30,energy=0,network=0,filesystem=0',
                                 'JobCheckpointDir=/var/spool/slurmctld.checkpoint',
                                 'JobCompType=jobcomp/none',
                                 'JobRequeue=1',
                                 'KillOnBadExit=0',
                                 'KillWait=30',
                                 'LaunchType=launch/slurm',
                                 'LogTimeFormat=iso8601_ms',
                                 'MailProg=/bin/mail',
                                 'MaxArraySize=1001',
                                 'MaxJobCount=10000',
                                 'MaxJobId=67043328',
                                 'MaxStepCount=40000',
                                 'MaxTasksPerNode=512',
                                 'MCSPlugin=mcs/none',
                                 'MemLimitEnforce=no',
                                 'MessageTimeout=10',
                                 'MinJobAge=300',
                                 'MpiDefault=none',
                                 'OverTimeLimit=0',
                                 'PlugStackConfig=/etc/slurm/plugstack.conf',
                                 'PluginDir=/usr/lib64/slurm',
                                 'PreemptMode=OFF',
                                 'PreemptType=preempt/none',
                                 'PriorityCalcPeriod=5',
                                 'PriorityDecayHalfLife=7-0',
                                 'PriorityFavorSmall=NO',
                                 'PriorityMaxAge=7-0',
                                 'PrioritySiteFactorPlugin=site_factor/none',
                                 'PriorityType=priority/basic',
                                 'PriorityUsageResetPeriod=NONE',
                                 'PriorityWeightAge=0',
                                 'PriorityWeightAssoc=0',
                                 'PriorityWeightFairshare=0',
                                 'PriorityWeightJobSize=0',
                                 'PriorityWeightPartition=0',
                                 'PriorityWeightQOS=0',
                                 'PriorityWeightTRES=0',
                                 'ProctrackType=proctrack/cgroup',
                                 'PropagatePrioProcess=0',
                                 'PropagateResourceLimits=ALL',
                                 'ResumeRate=300',
                                 'ResumeTimeout=60',
                                 'ResvOverRun=0',
                                 'ReturnToService=0',
                                 'RoutePlugin=route/default',
                                 'SchedulerTimeSlice=30',
                                 'SchedulerType=sched/backfill',
                                 'SelectType=select/linear',
                                 'SlurmctldDebug=info',
                                 'SlurmctldHost=slurm',
                                 'SlurmctldLogFile=/var/log/slurm/slurmctld.log',
                                 'SlurmctldPidFile=/var/run/slurmctld.pid',
                                 'SlurmctldPort=6817',
                                 'SlurmctldTimeout=120',
                                 'SlurmdDebug=info',
                                 'SlurmdLogFile=/var/log/slurm/slurmd.log',
                                 'SlurmdPidFile=/var/run/slurmd.pid',
                                 'SlurmdPort=6818',
                                 'SlurmdSpoolDir=/var/spool/slurmd',
                                 'SlurmdTimeout=300',
                                 'SlurmdUser=root',
                                 'SlurmSchedLogFile=/var/log/slurm/slurmsched.log',
                                 'SlurmSchedLogLevel=0',
                                 'SlurmUser=slurm',
                                 'StateSaveLocation=/var/spool/slurmctld.state',
                                 'SuspendRate=60',
                                 'SuspendTime=-1',
                                 'SuspendTimeout=30',
                                 'SwitchType=switch/none',
                                 'TaskPlugin=task/affinity,task/cgroup',
                                 'TCPTimeout=2',
                                 'TmpFS=/tmp',
                                 'TopologyPlugin=topology/none',
                                 'TreeWidth=50',
                                 'UnkillableStepTimeout=60',
                                 'UsePAM=1',
                                 'VSizeFactor=0',
                                 'WaitTime=0',
                                 'Include /etc/slurm/nodes.conf',
                                 'Include /etc/slurm/partitions.conf',
                               ])
  end

  it do
    is_expected.to contain_concat('slurm-partitions.conf').with(ensure: 'present',
                                                                path: '/etc/slurm/partitions.conf',
                                                                owner: 'root',
                                                                group: 'root',
                                                                mode: '0644')
  end

  it do
    is_expected.to contain_concat('slurm-nodes.conf').with(ensure: 'present',
                                                           path: '/etc/slurm/nodes.conf',
                                                           owner: 'root',
                                                           group: 'root',
                                                           mode: '0644')
  end

  it do
    is_expected.to contain_concat('slurm-topology.conf').with(ensure: 'present',
                                                           path: '/etc/slurm/topology.conf',
                                                           owner: 'root',
                                                           group: 'root',
                                                           mode: '0644')
  end

  it do
    is_expected.to contain_file('plugstack.conf.d').with(ensure: 'directory',
                                                         path: '/etc/slurm/plugstack.conf.d',
                                                         recurse: 'true',
                                                         purge: 'true',
                                                         owner: 'root',
                                                         group: 'root',
                                                         mode: '0644')
  end

  it do
    is_expected.to contain_file('plugstack.conf').with(ensure: 'file',
                                                       path: '/etc/slurm/plugstack.conf',
                                                       owner: 'root',
                                                       group: 'root',
                                                       mode: '0644')
  end

  it do
    verify_exact_file_contents(catalogue, 'plugstack.conf', [
                                 'include /etc/slurm/plugstack.conf.d/*.conf',
                               ])
  end

  it do
    is_expected.to contain_file('slurm-cgroup.conf').with(ensure: 'file',
                                                          path: '/etc/slurm/cgroup.conf',
                                                          owner: 'root',
                                                          group: 'root',
                                                          mode: '0644')
  end

  it 'has cgroup.conf with valid contents' do
    verify_exact_file_contents(catalogue, 'slurm-cgroup.conf', [
                                 'CgroupAutomount=yes',
                                 'CgroupMountpoint=/sys/fs/cgroup',
                                 'AllowedRAMSpace=100',
                                 'AllowedSwapSpace=0',
                                 'ConstrainCores=no',
                                 'ConstrainDevices=no',
                                 'ConstrainKmemSpace=no',
                                 'ConstrainRAMSpace=no',
                                 'ConstrainSwapSpace=no',
                                 'MaxRAMPercent=100',
                                 'MaxSwapPercent=100',
                                 'MaxKmemPercent=100',
                                 'MinKmemSpace=30',
                                 'MinRAMSpace=30',
                                 'TaskAffinity=no',
                               ])
  end

  it do
    is_expected.to contain_sysctl('net.core.somaxconn').with(ensure: 'present',
                                                             value: '1024')
  end

  context 'when use_syslog => true' do
    let(:param_override) { { use_syslog: true } }

    it do
      is_expected.to contain_file('slurm.conf') \
        .without_content(%r{^SlurmctldLogFile.*$}) \
        .without_content(%r{^SlurmdLogFile.*$})
    end
  end

  context 'when slurm_conf_override defined' do
    let :param_override do
      {
        slurm_conf_override: {
          'PreemptMode' => 'SUSPEND,GANG',
          'PreemptType'         => 'preempt/partition_prio',
          'ProctrackType'       => 'proctrack/linuxproc',
          'SchedulerParameters' => [
            'bf_continue',
            'defer',
          ],
        },
      }
    end

    it 'overrides values' do
      verify_contents(catalogue, 'slurm.conf', [
                        'PreemptMode=SUSPEND,GANG',
                        'PreemptType=preempt/partition_prio',
                        'ProctrackType=proctrack/linuxproc',
                        'SchedulerParameters=bf_continue,defer',
                      ])
    end
  end

  context 'when partitions defined' do
    let :param_override do
      {
        partitions: {
          'DEFAULT' =>
             {
               'nodes'         => 'c[0-9]',
               'state'         => 'UP',
             },
          'general' => {
            'max_nodes' => '1',
            'max_time' => '48:00:00',
            'default' => 'YES',
          },
        },
      }
    end

    it do
      verify_exact_fragment_contents(catalogue, 'slurm-partitions.conf-DEFAULT', [
                                       'PartitionName=DEFAULT Nodes=c[0-9] State=UP',
                                     ])
    end
    it do
      verify_exact_fragment_contents(catalogue, 'slurm-partitions.conf-general', [
                                       'PartitionName=general Default=YES MaxNodes=1 MaxTime=48:00:00 State=UP',
                                     ])
    end
  end

  context 'when nodes defined' do
    let :param_override do
      {
        nodes: { 'c01' =>
                   {
                     'cpus' => 4,
                     'node_hostname' => 'c01',
                     'node_addr' => '10.0.0.1',
                   },
                 'c02' => {
                   'cpus' => 4,
                   'node_hostname' => 'c02',
                   'node_addr' => '10.0.0.2',
                 } },
      }
    end

    it do
      verify_exact_fragment_contents(catalogue, 'slurm-nodes.conf-c01', [
                                       'NodeName=c01 NodeHostname=c01 NodeAddr=10.0.0.1 CPUs=4 State=UNKNOWN',
                                     ])
    end
    it do
      verify_exact_fragment_contents(catalogue, 'slurm-nodes.conf-c02', [
                                       'NodeName=c02 NodeHostname=c02 NodeAddr=10.0.0.2 CPUs=4 State=UNKNOWN',
                                     ])
    end
  end

  context 'when switches defined' do
    let :param_override do
      {
        switches: { 'switch01' =>
                   {
                     'nodes' => 'c01',
                   },
                 'switch00' => {
                   'switches' => 'switch01',
                 } },
      }
    end

    it do
      verify_exact_fragment_contents(catalogue, 'slurm-topology.conf-switch01', [
                                       'SwitchName=switch01 Nodes=c01',
                                     ])
    end
    it do
      verify_exact_fragment_contents(catalogue, 'slurm-topology.conf-switch00', [
                                       'SwitchName=switch00 Switches=switch01',
                                     ])
    end
  end

  context 'when GRESes defined' do
    let :param_override do
      {
        greses: { 'gpu' =>
                   {
                     'node_name' => 'c0[1-2]',
                     'file' => '/dev/nvidia[0-1]',
                   },
                 'gpu2' => {
                   'gres_name' => 'gpu',
                   'node_name' => 'c0[3-4]',
                   'file' => '/dev/nvidia[0-3]',
                 } },
      }
    end

    it do
      verify_exact_fragment_contents(catalogue, 'slurm-gres.conf-gpu', [
                                       'Name=gpu NodeName=c0[1-2] File=/dev/nvidia[0-1]',
                                     ])
    end
    it do
      verify_exact_fragment_contents(catalogue, 'slurm-gres.conf-gpu2', [
                                       'Name=gpu NodeName=c0[3-4] File=/dev/nvidia[0-3]',
                                     ])
    end
  end

  context 'when manage_slurm_conf => false' do
    let(:param_override) {  { manage_slurm_conf: false } }

    it { is_expected.not_to contain_file('slurm.conf') }
    it { is_expected.not_to contain_concat('slurm-partitions.conf') }
    it { is_expected.not_to contain_concat('slurm-nodes.conf') }
    it { is_expected.not_to contain_concat('slurm-topology.conf') }
    it { is_expected.not_to contain_file('plugstack.conf.d') }
    it { is_expected.not_to contain_file('plugstack.conf') }
    it { is_expected.not_to contain_file('slurm-cgroup.conf') }
    it { is_expected.not_to contain_file('cgroup_allowed_devices_file.conf') }
  end

  context 'when slurm_conf_source => "file:///path/slurm.conf"' do
    let(:param_override) {  { slurm_conf_source: 'file:///path/slurm.conf' } }

    it { is_expected.to contain_file('slurm.conf').without_content }
    it { is_expected.to contain_file('slurm.conf').with_source('file:///path/slurm.conf') }
  end

  context 'when partition_source => "file:///path/partitions.conf"' do
    let(:param_override) { { partition_source: 'file:///path/partitions.conf' } }

    it { is_expected.to contain_concat__fragment('slurm-partitions.conf-source').with_source('file:///path/partitions.conf') }
  end

  context 'when node_source => "file:///path/nodes.conf"' do
    let(:param_override) {  { node_source: 'file:///path/nodes.conf' } }

    it { is_expected.to contain_concat__fragment('slurm-nodes.conf-source').with_source('file:///path/nodes.conf') }
  end

  context 'when topology_source => "file:///path/topology.conf"' do
    let(:param_override) {  { topology_source: 'file:///path/topology.conf' } }

    it { is_expected.to contain_concat__fragment('slurm-topology.conf-source').with_source('file:///path/topology.conf') }
  end

  context 'when cgroup_conf_source => "file:///path/cgroup.conf"' do
    let(:param_override) { { cgroup_conf_source: 'file:///path/cgroup.conf' } }

    it { is_expected.to contain_file('slurm-cgroup.conf').without_content }
    it { is_expected.to contain_file('slurm-cgroup.conf').with_source('file:///path/cgroup.conf') }
  end
end
