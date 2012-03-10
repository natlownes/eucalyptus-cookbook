require_recipe 'eucalyptus::default'

if node[:euca][:hypervisor] == 'kvm'
  require_recipe 'kvm'
end

# euca nc
#
packages = %w(ntpdate open-iscsi libcrypt-openssl-random-perl libcrypt-openssl-rsa-perl libcrypt-x509-perl eucalyptus-nc)

packages.each do |pkg|
  package pkg do
    options "--force-yes"
    action :install
  end
end

execute 'run-euca_conf-setup' do
  command 'euca_conf --setup'
end

template "/etc/libvirt/qemu.conf" do
  source "qemu.conf.erb"
  variables(
    :euca_user => node[:euca][:user]
  )
end 

template "/etc/libvirt/libvirtd.conf" do
  source "libvirtd.conf.erb"
end

sockets = ['/var/run/libvirt/libvirt-sock', '/var/run/libvirt/libvirt-sock-ro']

sockets.each do |skt|
  execute "ensure ownership of #{skt}" do
    command "chown root:libvirt #{skt}"
  end
end

cron "sync time with cloud-controller" do
  command "/usr/sbin/ntpdate #{node[:euca][:front_end]}"
  user    'root'

  minute  '*/3'
end

ruby_block 'update-loop-devices-in-etc-modules' do
  block do
    existing_etc_modules = File.read("/etc/modules")
    loop_entry = "loop max_loop=64\n"
    if existing_etc_modules.match(/^loop/)
      existing_etc_modules.gsub(/^loop/, loop_entry)
    else
      existing_etc_modules << loop_entry
    end

    File.open("/etc/modules", 'w+') do |f|
      f << existing_etc_modules
    end
  end
end


template "/etc/eucalyptus/eucalyptus.conf" do
  # right now this is just set for
  # STATIC networking mode
  source "eucalyptus.conf.erb"
  owner 'eucalyptus'
  variables(
    :hypervisor => node[:euca][:hypervisor],
    :compute_nodes => node[:euca][:compute_nodes],

    :instance_path => node[:euca][:instance_path],

    :vnet_pubinterface =>  node[:euca][:network][:node][:pub_interface],
    :vnet_privinterface => node[:euca][:network][:node][:priv_interface],

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

  notifies :run,          resources(:execute => "ensure-euca-ownership-of-configs"), :immediately
  notifies :restart,      resources(:service => "eucalyptus-nc"), :immediately
  action :create
end

