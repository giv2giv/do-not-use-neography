class Node

  attr_accessor :attributes

  def self.node_attribute(arg)
    @keys << arg
  end

  def initialize(attr_hash) 
    @attributes=attr_hash
  end

  def id
    @attributes[:id]
  end

  

end
