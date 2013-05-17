require 'neo4j'

root_dir = File.expand_path "#{File.dirname(__FILE__)}/.."
load "#{root_dir}/lib/functions.rb"

class Donor
  include Neo4j::NodeMixin
  include Neo4j::RelationshipMixin

  property :email
  property :name
  property :password
  property :address
  property :city
  property :state
  property :zip
  property :country
  property :facebook_token
  property :dwolla_token
  property :twitter_token

  # The following setups up an index in lucene for these items and defines find_by_... methods
  index :email 
  index :name  
  index :dwolla_token 
  index :twitter_token 

  has_one :funding_source # links thid donor to a dwolla account
  has_n   :endowments    
  has_n   :donations

end #Donor class




