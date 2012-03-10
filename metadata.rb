maintainer       "Nat Lownes"
maintainer_email "nat.lownes@gmail.com"
name             'eucalyptus'
license          "Apache 2.0"
description      "Installs/Configures eucalyptus-cookbook"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"

attribute 'euca/front_end',
  :description => %{Your cloud controller's (resolvable) hostname or IP address},
  :required => 'required',
  :type => 'string'

attribute 'euca/compute_nodes',
  :description => %{your compute nodes resolvable hostname or IP addresses},
  :type => 'array'

attribute 'euca/storage_controllers',
  :description => %{your storage controllers resolvable hostname or IP addresses},
  :type => 'array'

attribute 'euca/walruses',
  :description => %{your walruses' resolvable hostname or IP addresses},
  :type => 'array'

attribute 'euca/ssh_private_key',
  :description => 'private key',
  :type => 'string',
  :required => 'required'

attribute 'euca/ssh_public_key',
  :description => 'public key',
  :type => 'string',
  :required => 'required'


dependencies = %w(apt ntp kvm)

dependencies.each do |dep|
  depends dep
end

distros = %w(debian)

distros.each do |dist|
  supports dist
end
