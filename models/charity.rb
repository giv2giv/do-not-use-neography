#This is broken - errors with:  models/charity.rb:9:in `initialize': undefined method `create' for nil:NilClass (NoMethodError)
#Should be fixed. the proper way to call it is with .new
class Charity

	@node = nil

	def initialize ( ein, name, address, city, state, zip, ntee_common_code, ntee_core_code )

		@node = Neography::Node.create(
			"ein" => ein,
			"name" => name,
			"address" => address,
			"city" => city,
			"state" => state,
			"zip" => zip,
			"ntee_common_code" => ntee_common_code,
			"ntee_core_code" => ntee_core_code
		)

		@node.add_to_index(CHARITY_NAME_INDEX, CHARITY_NAME_INDEX, name)
 		@node.add_to_index(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, ein)
 		@node.add_to_index(TYPE_INDEX, TYPE_INDEX, CHARITY_TYPE)

	end # initialize

	def find ( key )

		@node = Neography::Node.find(GIV2GIV_INDEX, GIV2GIV_INDEX, key)

	end # find

end

