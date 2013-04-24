
load 'lib/functions.rb'

class Charity

	attr_accessor :node

	def self.create( ein=nil, name=nil, address=nil, city=nil, state=nil, zip=nil, ntee_common_code=nil, ntee_core_code=nil )

		@node = Neography::Node.create(
                        "id" => generate_unique_id(),
			"ein" => ein,
			"name" => name,
			"address" => address,
			"city" => city,
			"state" => state,
			"zip" => zip,
			"ntee_common_code" => ntee_common_code,
			"ntee_core_code" => ntee_core_code
		)

		# Adding the node to an index 
		@node.add_to_index(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, ein)
		@node.add_to_index(CHARITY_NAME_INDEX, CHARITY_NAME_INDEX, name)
		@node.add_to_index(ID_INDEX, ID_INDEX, @node.id)

		# Not sure if this works - add node as type "Charity" for easy retrieval of all charities
		@node.add_to_index(TYPE_INDEX, TYPE_INDEX, CHARITY_TYPE)

	end # initialize

	def self.find_by_ein( ein )

		@node = Neography::Node.find(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, ein)
		rescue Neography::NeographyError => err # Don't throw the error

	end # find

	def self.find_by_id( id )

                @node = Neography::Node.find(ID_INDEX, ID_INDEX, id)
                rescue Neography::NeographyError => err # Don't throw the error

        end # find

	def self.find_by_name( name )

		@neo4j = Neography::Rest.new

		# This is best done using a Cypher query, so it's a little different

		# This doesn't work, but *should*
		Neography::Rest.new.find_node_index(CHARITY_NAME_INDEX, "name:#{name}*").map { |n| n["data"]["name"] }.to_json
		rescue Neography::NeographyError => err # Don't throw the error


  		#query = "name:#{name}*"
		#cypher = "START n=node:#{CHARITY_NAME_INDEX}('#{query}*') return n.name LIMIT 15"
  			#@neo4j.execute_query(cypher, 
                    		#{:query => query })["data"].map{|x| 
                           		#{ label: x[1], 
                             		#value: x[0] }
                         	#}.to_json 

	end #  find_name

	def self.delete( id)

		@node = Neography::Node.find(ID_INDEX, ID_INDEX, id)
		@node.remove_node_from_index()
		@node.del

	end

end
