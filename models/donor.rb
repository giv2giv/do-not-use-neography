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
			"node_id" => node_id, #need a way to auto-increment this 
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
		puts "Deleting ...... "
		puts donor
		donor.remove_node_from_index() # not sure if this removes from all indices
		donor.del
#		Neography::Node.delete(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)
	end

	def add_attribute( hash = {} )
		object=self
		attribute=hash[:attribute]
		property=hash[:property]
		
		#TODO this should be a method that allows us to arbirtrarily add attributes on the nodes either to all instances or to an individual instance
		yield
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

  	# The following commented out code doesn't work. It seems to make a LOT more sense just to use .add_property instead of a method missing
	# Define on self, since it's  a class method
	# This will allow us to create new node properties on the fly by calling object.newproperty=value,
	# because there will be no method called 'newproperty', so it will hit this method, and assign the value to a node property
#	def self.method_missing(method_sym, *arguments, &block)
		# the first argument is a Symbol, so you need to_s it if you want to pattern match
#		if method_sym.to_s =~ /^=*.$/
#			new_property=method_sym.to_s
#			value=arguments.first
			
			#@donor = Neography::Node.find(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, "fun@happy.com")
#			@donor = Neography::Node.create("email"=> "fun@happy.com")#
#			@donor.:new_property = value		#need to reference the object itself here, where 'self' is
#			find($1.to_sym => arguments.first)
#		else
#			super
#		end
#	end


	# It's important to know Object defines respond_to to take two parameters: the method to check, and whether to include private methods
	# http://www.ruby-doc.org/core/classes/Object.html#M000333
#	def self.respond_to?(method_sym, include_private = false)
#		if method_sym.to_s =~ /^find_by_(.*)$/
#			true
#		else
#			super
#		end
#	end







end #Donor class




