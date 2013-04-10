
class Charity

	attr_accessor :neo4j

	def create( ein, name, address, city, state, zip, ntee_common_code, ntee_core_code )

		@neo4j = Neography::Node.create(
			"ein" => ein,
			"name" => name,
			"address" => address,
			"city" => city,
			"state" => state,
			"zip" => zip,
			"ntee_common_code" => ntee_common_code,
			"ntee_core_code" => ntee_core_code
		)

		@neo4j.add_to_index(CHARITY_NAME_INDEX, CHARITY_NAME_INDEX, name)
 		@neo4j.add_to_index(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, ein)
 		@neo4j.add_to_index(TYPE_INDEX, TYPE_INDEX, CHARITY_TYPE)

	end # initialize

	def self.find_ein( ein )

		@neo4j = Neography::Node.find(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, ein)

	end # find

	def self.find_name( name )

		neo = Neography::Rest.new

		results = neo.execute_query("start n = node:#{CHARITY_NAME_INDEX}('name:#{name}*') return n")

		if results.nil?
			{ :error => "No match for #{name}" }.to_json
		else
			results.to_json
		end

	end #  find_name

end
