default[:euca][:install][:version] = "2.0.3"
default[:euca][:tarball_url] = "https://s3.amazonaws.com/tgerla-euca/euca-debian-2.0.3-mirror.tar.gz"

default[:euca][:user] = "eucalyptus"
default[:euca][:hypervisor] = "kvm"
# cluster_name will be your 'availability zone'
default[:euca][:cluster_name] = "cluster0"
default[:euca][:front_end] = ""
default[:euca][:compute_nodes] = %w()
default[:euca][:storage_controllers] = %w()
default[:euca][:walruses] = %w()

default[:euca][:instance_path] = "/var/lib/eucalyptus/instances"

default[:euca][:network][:front_end][:pub_interface] = "eth0"
default[:euca][:network][:front_end][:priv_interface] = "eth0"
default[:euca][:network][:node][:pub_interface] = "eth0"
default[:euca][:network][:node][:priv_interface] = "eth0"
default[:euca][:network][:vnet][:bridge] = "br0"

default[:euca][:network][:node][:mode] = 'dhcp'

# todo:  static config
#
#default[:euca][:network][:node][:mode] = 'static'
#default[:euca][:network][:node][:config][:static][:address]
#default[:euca][:network][:node][:config][:static][:network]
#default[:euca][:network][:node][:config][:static][:netmask]
#default[:euca][:network][:node][:config][:static][:broadcast]
#default[:euca][:network][:node][:config][:static][:gateway]

default[:euca][:network][:vnet][:mode] = "MANAGED"
default[:euca][:network][:vnet][:subnet] = "172.20.0.0"
default[:euca][:network][:vnet][:netmask] = "255.255.0.0"
default[:euca][:network][:vnet][:broadcast] = "172.20.255.255"
default[:euca][:network][:vnet][:router] = "10.0.0.1"
default[:euca][:network][:vnet][:dns] = "10.0.0.1"
default[:euca][:network][:vnet][:mac_map] = []

default[:euca][:network][:vnet][:addresses_per_net] = "16"
default[:euca][:network][:vnet][:public_ips_start] = "10.0.129.10"
default[:euca][:network][:vnet][:public_ips_end] = "10.0.129.200"

# override these
default[:euca][:ssh_private_key] = ""
default[:euca][:ssh_public_key] = ""

