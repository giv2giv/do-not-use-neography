
class Charity

	attr_accessor :node

	def self.create( ein=nil, name=nil, address=nil, city=nil, state=nil, zip=nil, ntee_common_code=nil, ntee_core_code=nil )

		# Since we're adding to indexes we must use Phase 1
		@neo4j = Neography::Rest.new

		@node = @neo4j.create_node(
			"ein" => ein,
			"name" => name,
			"address" => address,
			"city" => city,
			"state" => state,
			"zip" => zip,
			"ntee_common_code" => ntee_common_code,
			"ntee_core_code" => ntee_core_code
		)

		# Adding the node to an index via
		@neo4j.add_node_to_index(CHARITY_NAME_INDEX, CHARITY_NAME_INDEX, name, @node)
 		@neo4j.add_node_to_index(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, ein, @node)
 		@neo4j.add_node_to_index(TYPE_INDEX, TYPE_INDEX, CHARITY_TYPE, @node)

	end # initialize

	def self.find_by_ein( ein )

		@neo4j = Neography::Rest.new

		# Set the class variable to the found node(s) & return either the node or nil
		@node = @neo4j.get_node_index(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, ein)

	end # find

	def self.find_by_name( name )

		@neo4j = Neography::Rest.new

		# This is best done using a Cypher query, so it's a little different

		# this is now re-broken

		cypher = "START me=node:#{CHARITY_NAME_INDEX}({query}) 
            		me.name
            		ORDER BY me.name
            		LIMIT 15"
  			query = "name:*#{name}*"
  			@neo4j.execute_query(cypher, 
                    		{:query => query })["data"].map{|x| 
                           		{ label: x[1], 
                             		value: x[0] }
                         	}.to_json   

	end #  find_name

end
