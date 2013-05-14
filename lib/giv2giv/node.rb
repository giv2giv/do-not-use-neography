class Node
  class << self; attr_accessor :keys end
  attr_accessor :attributes

  def self.node_attribute(arg)
  	self.keys ||= []
    self.keys << arg.to_sym

    # Create Getter and Setter, which just read and set the attribute
    # in the array.
    self.class_eval("def #{arg};@attributes[:#{arg}];end")
    self.class_eval("def #{arg}=(val);@attributes[:#{arg}]=val;end")
  end

  def type
    @attributes[:type]
  end
  def type=(arg)
    @attributes[:type] = arg
  end

  def initialize(attr_hash)
    if (self.class.keys-attr_hash.keys).empty?
  		@attributes=attr_hash
      @attributes[:type] = self.class.name
    else
	  	raise Exception.new "Missing required attributes, " + (self.class.keys - attr_hash.keys).join(', ')
	  end
  end

  def id
    @attributes[:id]
  end

end
