actions :create, :delete, :nothing

attribute :cluster_name, :name_attribute => true
# IP address
attribute :host, :kind_of => String
attribute :exists, :default => false
attribute :supports, :create => true, :delete => true, :nothing => true 

def initialize(*args)
  super
  @action = :create
end
