include Chef::Mixin::ShellOut
include Chef::Mixin::Command

def load_current_resource
  hosts = new_resource.hosts
  new_resource.formatted_hosts(formatted_hosts(hosts))
  new_resource
end

action :create do
  add_nodes_command = %{euca_conf --register-nodes "#{new_resource.formatted_hosts}" }
  run_command :command => add_nodes_command, :ignore_failure => true
end

action :delete do
  remove_nodes_command = %{euca_conf --deregister-nodes "#{new_resource.formatted_hosts}" }
  run_command :command => remove_nodes_command, :ignore_failure => true
end

def formatted_hosts(hosts_array)
  hosts_array.join(' ')
end
