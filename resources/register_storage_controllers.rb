
actions :create, :delete, :nothing

attribute :cluster_name, :name_attribute => true
# node ip addresses or dns entries
attribute :hosts, :kind_of => Array
attribute :supports, :default => { :create => true, :delete => true, :noething => true }

attribute :existing_hosts, :kind_of => Array, :default => []

def initialize(*args)
  super
  @action = :create
end
