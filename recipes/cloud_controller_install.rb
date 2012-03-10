# euca cc
#
#
require_recipe 'eucalyptus::default'
require_recipe 'ntp'

packages = %w(eucalyptus-common eucalyptus-cloud eucalyptus-cc)

packages.each do |pkg|
  package pkg do
    options "--force-yes"
    action :install
    notifies :run, resources(:execute => 'euca-conf-setup'), :immediately
  end
end

template "/etc/eucalyptus/eucalyptus.conf" do
  source "eucalyptus.conf.erb"
  variables(
    :hypervisor => node[:euca][:hypervisor],
    :compute_nodes => node[:euca][:compute_nodes],

    :instance_path => node[:euca][:instance_path],

    :vnet_pubinterface =>  node[:euca][:network][:front_end][:pub_interface],
    :vnet_privinterface => node[:euca][:network][:front_end][:priv_interface],

    :vnet_bridge => node[:euca][:network][:vnet][:bridge],

    :vnet_mode =>    node[:euca][:network][:vnet][:mode],

    :subnet =>    node[:euca][:network][:vnet][:subnet],
    :netmask =>   node[:euca][:network][:vnet][:netmask],
    :broadcast => node[:euca][:network][:vnet][:broadcast],
    :router =>    node[:euca][:network][:vnet][:router],
    :dns =>       node[:euca][:network][:vnet][:dns],
    :mac_map =>   node[:euca][:network][:vnet][:mac_map].map {|mac,ipaddrr| "#{mac}=#{ipaddrr}" }.join(' '),

    :addresses_per_net =>       node[:euca][:network][:vnet][:addresses_per_net],
    :public_ips_start =>        node[:euca][:network][:vnet][:public_ips_start],
    :public_ips_end =>          node[:euca][:network][:vnet][:public_ips_end]

  )
  action :create

  notifies :restart,          resources(:service => 'ntp'), :immediately
  notifies :run,          resources(:execute => "ensure-euca-ownership-of-configs"), :immediately
  notifies :run,          resources(:execute => "eucalyptus-clean-restart"), :immediately
  notifies :restart,      resources(:service => "eucalyptus-cloud"), :immediately
end
