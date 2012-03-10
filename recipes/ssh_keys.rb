
private_key = node[:euca][:ssh_private_key]
public_key = node[:euca][:ssh_public_key]

directory "/root/.ssh" do
  action :create
  recursive true
end

ruby_block "write private key" do
  block do
    File.open("/root/.ssh/id_rsa", "w") do |file|
      file << private_key
    end
  end
end

ruby_block "write public key" do
  block do
    File.open("/root/.ssh/id_rsa.pub", "w") do |file|
      file << public_key
    end
  end
end

ruby_block "add authorized_key" do
  block do
    File.open("/root/.ssh/authorized_keys", "w+") do |file|
      file << public_key
    end
  end
end

template "/root/.ssh/config" do
  source "config.erb"
end

execute "ensure ssh permissions" do
  command "chmod -R 700 /root/.ssh"
end


