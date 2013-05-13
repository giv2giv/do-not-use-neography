class Node
  class << self; attr_accessor :keys end
  attr_accessor :attributes

  def self.node_attribute(arg)
	@keys ||= []
    @keys << arg
  end

  def initialize(attr_hash) 

    if (self.keys-attr_hash.keys).empty?
		@attributes=attr_hash
    else
		raise "Missing required attributes" + (self.keys - attr_hash.keys).join
	end

  end

  def id
    @attributes[:id]
  end

  

end
