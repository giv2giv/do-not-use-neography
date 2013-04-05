
# Not working

class Donor



	def initialize( name, address1, address2, city, state, country, zip, email, created_at, facebook_token, dwolla_token, twitter_token )

		# Create the node
		donor_node = Neography::Node.create(
			"email", email
			"name", name
			"address1", address1
			"address2", address2
			"city", city
			"state", state
			"country", country
			"zip", zip
			"node_id", node_id
			"created_at", created_at
			"zip", zip
			"facebook_token", facebook_token
			"dwolla_token", dwolla_token
			"twitter_token", twitter_token
			)


		# Add this node to the donor email index for easy retrieval using email
		donor_node.add_to_index(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, data["email"])
		donor_node.add_to_index(TYPE_INDEX, TYPE_INDEX, data["email"])

		return donor_node
	end
	
	def load ( email )

		self.donor_node = Neography::Node.find(DONOR_INDEX, "email", data["email"])

	end

	def add_funds(source)
		#connect to source (dwolla) via token
		#pull amount
		#add to account balance
	end

	def sign_up_for_endowment(endowment)
		# connect donor to endowment
		# schedule payment
		# social hooks for tweet/post/pinterest based on donor preferences
	end

	def total_funds()
		#return total funds across all merchant processors and investment funds
	end

	def donations(start_date=nil, end_date=nil, source=nil)
		# return total donations between periods
		# possibly filter by source (dwolla, paypal, etc)
	end


end #Donor class


