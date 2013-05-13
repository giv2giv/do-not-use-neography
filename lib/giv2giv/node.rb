class Node
  class << self; attr_accessor :keys end
  attr_accessor :attributes

  def self.node_attribute(arg)
	self.keys ||= []
    self.keys << arg
  end

  def initialize(attr_hash) 

    if (self.class.keys-attr_hash.keys).empty?
		@attributes=attr_hash
    else
		raise Exception.new "Missing required attributes, " + (self.class.keys - attr_hash.keys).join(', ')
	end
  end


  def id
    @attributes[:id]
  end

  

end
