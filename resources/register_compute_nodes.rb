
actions :create, :delete, :nothing

attribute :cluster_name, :name_attribute => true
# node ip addresses or dns entries
attribute :hosts, :kind_of => Array
attribute :supports, :default => { :create => true, :delete => true, :nothing => true }

attribute :formatted_hosts, :kind_of => String, :default => ''

def initialize(*args)
  super
  @action = :create
end
