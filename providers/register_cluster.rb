require 'socket'
include Chef::Mixin::ShellOut
include Chef::Mixin::Command

action :create do
  Chef::Log.debug(new_resource.inspect)
  Chef::Log.debug(new_resource.name)
  Chef::Log.debug("#{new_resource.name} cluster exists?: #{cluster_exists?(new_resource.name).inspect}")
  
  if !cluster_exists?(new_resource.name)
    ip_address = get_ip_address_from_hostname(new_resource.host)
    Chef::Log.debug("registering...#{new_resource.name} #{ip_address}")

    add_cluster_command = %{euca_conf --register-cluster "#{new_resource.name}" "#{ip_address}" }

    run_command :command => add_cluster_command, :ignore_failure => true
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if cluster_exists?(new_resource.name)
    Chef::Log.debug("de-registering...#{new_resource.name} #{new_resource.host}")
    remove_cluster_command %{euca_conf --deregister-cluster "#{new_resource.name}" "#{new_resource.host}" }

    run_command :command => remove_cluster_command, :ignore_failure => true
    new_resource.updated_by_last_action(true)
  end
end

def existing_clusters
  begin
    shell_out!("euca_conf --list-clusters").stdout
  rescue
    ""
  end
end

def cluster_exists?(cluster_name)
  existing_clusters.match(/#{cluster_name}/m)
end

def get_ip_address_from_hostname(hostname)
  Socket::getaddrinfo(hostname, 'www', nil, Socket::SOCK_STREAM)[0][3]
end
