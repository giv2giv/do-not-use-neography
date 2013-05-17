=begin

Classes should extend Node in order to save their attributes in a database.
To add attributes use the node_attribute() class level call.

NODE ATTRIBUTES
============================
class TestDonor < Node
   node_attribute :name
end

Creates a class called TestDonor that has a name attribute.  By setting this attribute
you get a getter and setter on name, and are garanteed that teh value will be persisted in the
database when you call NeoRest.save(my_node)

Calls to Save will set an id on the given node.

Find will find nodes with a given id.

To create relationships use the
relationship call()




=end
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

  # Getter and setter methods for Type.
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
