
class Charity

	@neo4j = nil  # instance variable for DB handle

	def create ( ein, name, address, city, state, zip, ntee_common_code, ntee_core_code )

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

	def find_ein ( ein )

		@neo4j = Neography::Node.find(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, ein)

	end # find

end
