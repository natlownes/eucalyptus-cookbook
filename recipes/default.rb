#
# Cookbook Name:: eucalyptus-cookbook
# Recipe:: default
#
# Copyright 2012, Fort Hill Company
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require_recipe 'apt'
require_recipe 'eucalyptus::ssh_keys'
require_recipe 'eucalyptus::cloud_controller_registration'

euca_version = node[:euca][:install][:version]

apt_repository "eucalyptus" do
  uri "http://eucalyptussoftware.com/downloads/repo/eucalyptus/#{euca_version}/debian/"
  distribution "squeeze"
  components %w(main)
  action :add
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

service "eucalyptus-nc" do
  action :nothing
end

service "eucalyptus-cloud" do
  action :nothing
end

service "eucalyptus-cc" do
  action :nothing
end

execute "eucalyptus-clean-restart" do
  command "/etc/init.d/eucalyptus-cc cleanrestart"
  notifies :create, resources(:eucalyptus_register_cluster => node[:euca][:cluster_name]), :delayed

  action :nothing
end

execute "ensure-euca-ownership-of-configs" do
  command "chown -R eucalyptus /etc/eucalyptus"
  action :nothing
end

execute 'euca-conf-setup' do
  command 'euca_conf --setup'
  action :nothing
end

service 'ntp' do
  action :nothing
end

package 'aoetools' do
  action :install
end

package 'bridge-utils' do
  action :install
end
