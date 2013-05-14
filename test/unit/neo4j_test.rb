ENV['RACK_ENV'] = 'test'
require 'test/unit'

root_dir = File.expand_path "#{File.dirname(__FILE__)}/../.."
require "#{root_dir}/lib/giv2giv/node"
require "#{root_dir}/lib/giv2giv/neo_rest"

class TestDonor < Node
  node_attribute :name
  node_attribute :email
end

class Neo4JTest < Test::Unit::TestCase

  def test_create    
    donor_dan  = TestDonor.new({:name => "Dan",  :email => "daniel.h.funk@gmail.com"})
    assert_equal "TestDonor", donor_dan.type
    assert_equal "Dan", donor_dan.name
    assert_equal "daniel.h.funk@gmail.com", donor_dan.email
    NeoRest.save!(donor_dan)
    assert_not_nil donor_dan.id
    assert donor_dan.id > 0
  end

  def test_find
    donor_dan  = TestDonor.new({:name => "Dan",  :email => "daniel.h.funk@gmail.com"})
    NeoRest.save!(donor_dan)
    donor_dan2 =  NeoRest.find(donor_dan.id)
    assert donor_dan2.instance_of? TestDonor
    assert_not_nil donor_dan2.id
    assert_equal  donor_dan.id, donor_dan2.id
    assert_equal "Dan", donor_dan2.name
    assert_equal "daniel.h.funk@gmail.com", donor_dan2.email
  end

  def test_modify
    donor_dan  = TestDonor.new({:name => "Dan",  :email => "daniel.h.funk@gmail.com"})
    NeoRest.save!(donor_dan)
    id         =  donor_dan.id
    donor_dan.name="Not Dan"
    NeoRest.save!(donor_dan)
    assert_equal id, donor_dan.id
    donor_dan  = NeoRest.find(id)
    assert_equal "Not Dan", donor_dan.name
  end

  def test_create_with_more_params
    donor_dan  = TestDonor.new({:name => "Dan",  :email => "daniel.h.funk@gmail.com", :person => "johnny"})
    NeoRest.save!(donor_dan)
    assert_not_nil donor_dan.id
    assert_not_nil NeoRest.find(donor_dan.id)
  end

  # Creating a test donor without the base attributes failes.
  def test_fail_create    
    assert_raises Exception do 
      donor=TestDonor.new({:person=>"john"})
    end
  end

  def test_put
	bob =  NeoRest.put(11222, "state", "virginia")
#	bob2 = NeoRest.get(11222)
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
