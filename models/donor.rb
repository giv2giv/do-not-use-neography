
# Not working

class Donor



	def initialize( name, address1, address2, city, state, country, zip, email, created_at, facebook_token, dwolla_token, twitter_token )

		# Create the node
		donor_node = Neography::Node.create(
			"email" => data["email"]
			"name"  => data["name"]
			"address1"  => data["address1"]
			"address2"  => data["address2"]
			"city"  => data["city"]
			"state"  => data["state"]
			"country"  => data["country"]
			"zip"  => data["zip"]
			"node_id"  => data["node_id"]
			"created_at"  => data["created_at"]
			"zip"  => data["zip"]
			"facebook_token"  => data["facebook_token"]
			"dwolla_token"  => data["dwolla_token"]
			"twitter_token"  => data["twitter_token"]
			)


		# Add this node to the donor email index for easy retrieval using email
		donor_node.add_to_index(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, data["email"])
		donor_node.add_to_index(TYPE_INDEX, TYPE_INDEX, data["email"])

		return donor_node
	end
	
	# Add this node to the donor email index for easy retrieval using email
	donor_node.add_to_index(DONOR_EMAIL_INDEX, "email", data["email"])


#may not need following line if we dont use datamapper, which makes a certain amount of sense
#include DataMapper::Resource 

#property :something Serial    # An auto-increment integer key




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


end


