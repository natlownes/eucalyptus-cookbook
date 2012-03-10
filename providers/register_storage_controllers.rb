include Chef::Mixin::ShellOut
include Chef::Mixin::Command

def load_current_resource
  existing_scs = new_resource.hosts.select do |host|
    storage_controller_exists?(host)
  end
  new_resource.existing_hosts(existing_scs)
  new_resource
end

action :create do
  new_resource.hosts.each do |host|
    scs_command = %{euca_conf --register-sc "#{new_resource.cluster_name}" "#{host}" }
    run_command :command => scs_command, :ignore_failure => true
  end
end

action :delete do
  rm_sc_command = %{euca_conf --deregister-sc "#{new_resource.cluster_name}" }
  run_command :command => rm_sc_command, :ignore_failure => true
end

def existing_storage_controllers
  begin
    shell_out!("euca_conf --list-scs").stdout
  rescue
    ""
  end
end

def storage_controller_exists?(cluster_name)
  existing_storage_controllers.match(/#{cluster_name}/m)
end

def formatted_hosts(hosts_array)
  hosts_array.join(' ')
end
