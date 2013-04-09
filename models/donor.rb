require 'bcrypt'
# Not working

class Donor


	def self.create( name, email, password, address1, address2, city, state, country, zip, node_id, created_at, facebook_token, dwolla_token, twitter_token )

		# Create the node
		@donor_node = Neography::Node.create(
			"name" => name,
			"password" => BCrypt::Password.create(password),
			"email" => email,
			"address1" => address1,
			"address2" => address2,
			"city" => city,
			"state" => state,
			"country" => country,
			"zip" => zip,
			"node_id" => node_id, #need a way to auto-increment this --- actually it's already auto-incrementing them, really. it labels them "node XX" where XX is a number
			"created_at" => created_at,
			"facebook_token" => facebook_token,
			"dwolla_token" => dwolla_token,
			"twitter_token" => twitter_token,
			)


		# Add this node to the donor email index for easy retrieval using email
		@donor_node.add_to_index(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)
		@donor_node.add_to_index(TYPE_INDEX, TYPE_INDEX, email)

		return @donor_node
	end #initialize
	
	def self.find ( email )

		@donor = Neography::Node.find(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)

	end

	def self.delete(email)
		donor=Neography::Node.find(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)
		#puts "test"
		#puts donor
##		puts self
		#puts "^^^^^^^  THIS SHOULD BE DELETED"
		donor.remove_node_from_index() # not sure if this removes from all indices
		donor.del
#		Neography::Node.delete(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)
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




