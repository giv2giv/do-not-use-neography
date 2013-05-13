ENV['RACK_ENV'] = 'test'
require 'test/unit'
#require '/lib/giv2giv/node.rb'

require File.expand_path '../../lib/giv2giv/node', __FILE__
require File.expand_path '../../lib/giv2giv/neo_rest', __FILE__

class TestDonor < Node
  node_attribute :name
  node_attribute :email
end

class Neo4JTest < Test::Unit::TestCase

  def test_create    
    donor_dan  = TestDonor.new({:name => "Dan",  :email => "daniel.h.funk@gmail.com"})
    NeoRest.save!(donor_dan)    
    assert_not_nil donor_dan.id
    assert_not_nil NeoRest.find(donor_dan.id)
  end

  def test_fail_create
    assert_raises do 
      donor=TestDonor.new({:person=>"john"})
	end
  end

=begin
  def test_add_attribute
    donor_dan=TestDonor.new({:name=>"Booyah", :email => "pooppsie@mcpooples.com"})
	NeoRest.save!(donor_dan)
	donor_dan.attribute=value
  end
=end
  def test_relationship
#    donor_josh = TestDonor.new({:name => "Josh", :email => "jlegs@sexybarristas.com"})
#    donor_dan  = TestDonor.new({:name => "Dan",  :email => "daniel.h.funk@gmail.com"})
#    donor_dan.add_friend(donor_josh, {:type => "just friends", :desc => "no sexy sexy"})
#    Neo4J.save!(donor_dan)    
  end

end
