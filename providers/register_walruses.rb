include Chef::Mixin::ShellOut
include Chef::Mixin::Command

def load_current_resource
  existing_walruses = new_resource.hosts.select do |host|
    walrus_exists?(host)
  end
  new_resource.existing_hosts(existing_walruses)
  new_resource
end

action :create do
  new_resource.hosts.each do |host|
    add_walrus_command =  %{euca_conf --register-walrus "#{host}" }
    run_command :command => add_walrus_command, :ignore_failure => true
  end
end

action :delete do
  new_resource.existing_hosts.each do |host|
    rm_walrus_command =  %{euca_conf --deregister-walrus "#{host}" }
    run_command :command => rm_walrus_command, :ignore_failure => true
  end
end

def existing_walruses
  begin
    shell_out!("euca_conf --list-walruses").stdout
  rescue
    ""
  end
end

def walrus_exists?(cluster_name)
  existing_walruses.match(/#{cluster_name}/m)
end
