class Charity

	@node = Neography::Node

	def initialize ( ein, name, address, city, state, zip, ntee_core_code, ntee_common_code )

		@node.create(
			"ein" => ein,
			"name" => name,
			"address" => address,
			"city" => city,
			"state" => state,
			"zip" => zip,
			"ntee_common_code" => ntee_common_code,
			"ntee_core_code" => ntee_core_code
		)


	end

	def find ( key )

		@node.find(GIV2GIV_INDEX, GIV2GIV_INDEX, key)

	end

end

