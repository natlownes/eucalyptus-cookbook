#
# wait 'til services are up - i.e. other nodes, etc
#
require_recipe 'eucalyptus::default'

walruses = node[:euca][:walruses]
compute_nodes = node[:euca][:compute_nodes]
storage_controllers = node[:euca][:storage_controllers]
cluster_name = node[:euca][:cluster_name]
front_end = node[:euca][:front_end]

package 'euca2ools' do
  action :install
end

eucalyptus_register_walruses node[:euca][:cluster_name] do
  hosts  walruses 

  action :nothing
end

eucalyptus_register_storage_controllers node[:euca][:cluster_name] do
  hosts storage_controllers

  action :nothing
end

eucalyptus_register_compute_nodes node[:euca][:cluster_name] do
  hosts compute_nodes

  action :nothing
end

eucalyptus_register_cluster node[:euca][:cluster_name] do
  host    node[:euca][:front_end] 

  notifies :create, resources(:eucalyptus_register_compute_nodes => node[:euca][:cluster_name]), :delayed
  notifies :create, resources(:eucalyptus_register_storage_controllers => node[:euca][:cluster_name]), :delayed
  notifies :create, resources(:eucalyptus_register_walruses => node[:euca][:cluster_name]), :delayed

  action :nothing
end

