# @summary Manage a SLURM partition configuration
#
#
#
# @param partition_name
# @param alloc_nodes
# @param allow_accounts
# @param allow_groups
# @param allow_qos
# @param alternate
# @param cpu_bind
# @param default
# @param def_cpu_per_gpu
# @param def_mem_per_cpu
# @param def_mem_per_gpu
# @param def_mem_per_node
# @param deny_accounts
# @param deny_qos
# @param default_time
# @param disable_root_jobs
# @param exclusive_user
# @param grace_time
# @param hidden
# @param lln
# @param max_cpus_per_node
# @param max_mem_per_cpu
# @param max_mem_per_node
# @param max_nodes
# @param max_time
# @param min_nodes
# @param nodes
# @param over_subscribe
# @param preempt_mode
# @param priority_job_factor
# @param priority_tier
# @param qos
# @param req_resv
# @param root_only
# @param select_type_parameters
# @param shared
# @param state
# @param tres_billing_weights
# @param order
#
define slurm::partition (
  $partition_name = $name,
  $alloc_nodes = undef,
  $allow_accounts = undef,
  $allow_groups = undef,
  $allow_qos = undef,
  $alternate = undef,
  $cpu_bind = undef,
  Optional[Enum['YES','NO']] $default = undef,
  $def_cpu_per_gpu = undef,
  $def_mem_per_cpu = undef,
  $def_mem_per_gpu = undef,
  $def_mem_per_node = undef,
  $deny_accounts = undef,
  $deny_qos = undef,
  $default_time = undef,
  Optional[Enum['YES','NO']] $disable_root_jobs = undef,
  Optional[Enum['YES','NO']] $exclusive_user = undef,
  $grace_time = undef,
  Optional[Enum['YES','NO']] $hidden = undef,
  Optional[Enum['YES','NO']] $lln = undef,
  $max_cpus_per_node = undef,
  $max_mem_per_cpu = undef,
  $max_mem_per_node = undef,
  $max_nodes = undef,
  $max_time = undef,
  $min_nodes = undef,
  $nodes = undef,
  Optional[Enum['EXCLUSIVE','FORCE','YES','NO']] $over_subscribe = undef,
  Optional[Slurm::PreemptMode] $preempt_mode = undef,
  $priority_job_factor = undef,
  $priority_tier = undef,
  $qos = undef,
  $req_resv = undef,
  Optional[Enum['YES','NO']] $root_only = undef,
  Optional[Slurm::SelectTypeParameters] $select_type_parameters = undef,
  $shared = undef,
  Slurm::PartitionState $state = 'UP',
  $tres_billing_weights = undef,
  $order            = '50',
) {

  include ::slurm

  $conf_values = {
    'PartitionName' => $partition_name,
    'AllocNodes' => $alloc_nodes,
    'AllowAccounts' => $allow_accounts,
    'AllowGroups' => $allow_groups,
    'AllowQos' => $allow_qos,
    'Alternate' => $alternate,
    'CpuBind' => $cpu_bind,
    'Default' => $default,
    'DefCpuPerGPU' => $def_cpu_per_gpu,
    'DefMemPerCPU' => $def_mem_per_cpu,
    'DefMemPerGPU' => $def_mem_per_gpu,
    'DefMemPerNode' => $def_mem_per_node,
    'DenyAccounts' => $deny_accounts,
    'DenyQos' => $deny_qos,
    'DefaultTime' => $default_time,
    'DisableRootJobs' => $disable_root_jobs,
    'ExclusiveUser' => $exclusive_user,
    'GraceTime' => $grace_time,
    'Hidden' => $hidden,
    'LLN' => $lln,
    'MaxCPUsPerNode' => $max_cpus_per_node,
    'MaxMemPerCPU' => $max_mem_per_cpu,
    'MaxMemPerNode' => $max_mem_per_node,
    'MaxNodes' => $max_nodes,
    'MaxTime' => $max_time,
    'MinNodes' => $min_nodes,
    'Nodes' => $nodes,
    'OverSubscribe' => $over_subscribe,
    'PreemptMode' => $preempt_mode,
    'PriorityJobFactor' => $priority_job_factor,
    'PriorityTier' => $priority_tier,
    'QOS' => $qos,
    'ReqResv' => $req_resv,
    'RootOnly' => $root_only,
    'SelectTypeParameters' => $select_type_parameters,
    'Shared' => $shared,
    'State' => $state,
    'TRESBillingWeights' => $tres_billing_weights,
  }


  concat::fragment { "slurm-partitions.conf-${name}":
    target  => 'slurm-partitions.conf',
    content => template($::slurm::partition_template),
    order   => $order,
  }

}
