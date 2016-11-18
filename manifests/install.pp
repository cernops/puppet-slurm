class slurm::install {
  # Here we either install packages or build from source

  # Interesting compile flags (https://slurm.schedmd.com/quickstart_admin.html)
  #
  # Checkpointing:
  # - BLCR The checkpoint/blcr plugin will be built if the blcr development library is present.
  # Performance:
  # - cgroup Task Affinity The task/cgroup plugin will be built with task affinity support if the hwloc development library is present.
  # - NUMA Affinity NUMA support in the task/affinity plugin will be available if the numa development library is installed.
  # Interesting if it comes for free:
  # - IPMI Engergy Consumption The acct_gather_energy/ipmi accouting plugin will be built if the freeimpi development library is present.
  # Check if we need this for any plugin:
  # - Lua Support The lua API will be available in various plugins if the lua development library is present.
  # Our DB:
  # - MySQL MySQL support for accounting will be built if the mysql development library is present.
  # Maybe, if needed for security/AUKS:
  # - OpenSSL The crypto/openssl CryptoType plugin will be built if the openssl development library is present.
  # - PAM Support PAM support will be added if the PAM development library is installed.
  # Maybe nice to have for scripts:
  # - Readline Support Readline support in scontrol and sacctmgr's interactive modes will be available if the readline development library is present.
  # Graphical information about partitions (queues), resources etc:
  # - smap The smap command will be built only if the ncurses development library is installed.
  # - sview The sview command will be built only if gtk+-2.0 is installed.

  # List of dependencies to yum install if we want these flags:
  # yum install -y openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel ncurses-devel mariadb-devel
}
