require 'bcrypt'
# Not working

load 'lib/functions.rb'

class Donor
	
	def self.create( name, email, password, address1, address2, city, state, country, zip, facebook_token, dwolla_token, twitter_token )

		# Create the node
		@node = Neography::Node.create(
			"id" => generate_unique_id(),
			"name" => name,
			"password" => BCrypt::Password.create(password).to_s,
			"email" => email,
			"address1" => address1,
			"address2" => address2,
			"city" => city,
			"state" => state,
			"country" => country,
			"zip" => zip,
			"facebook_token" => facebook_token,
			"dwolla_token" => dwolla_token,
			"twitter_token" => twitter_token,
			"node_type" => "donor"
			)


		# Add this node to the donor email index for easy retrieval using email
		@node.add_to_index(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)
		@node.add_to_index(TYPE_INDEX, TYPE_INDEX, DONOR_TYPE)
		@node.add_to_index(ID_INDEX, ID_INDEX, @node.id)

		return @node
	end #initialize
	
	def self.find_by_email ( email )

		begin
		Neography::Node.find(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)
		rescue Neography::NeographyError => err # Don't throw the error
		end

	end

	def self.find_all()
		@db=Neography::Rest.new
		donors=@db.execute_query("start n=node(*) where has(n.node_type) and (n.node_type='donor') return *;")
#		puts
#		puts donors
#		puts
		real=donors["data"]
		puts donors
		puts
		puts real
		puts
		puts
		real.each do |new|
#		puts real[0].class
			new.each do |x|
				result=x["data"]
				puts result
				puts result["id"]
				puts "\t"+"#{result["name"]}"
				puts "\t"+"#{result["email"]}"
			end
		end

#		donors.each {|d| puts d.name, d.id}
	end


	def self.find_by_id( id )

		begin
	            @node = Neography::Node.find(ID_INDEX, ID_INDEX, id)
		rescue Neography::NeographyError => err # Don't throw the error
				puts "Received error: #{err}"
		end #begin

    end # find


	def self.delete(email)
		donor=Neography::Node.find(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)
		puts "Deleting ...... "
		puts donor
		donor.remove_node_from_index() # not sure if this removes from all indices
		donor.del
	end

	def add_attribute( key, value )
		#TODO this should be a method that allows us to arbirtrarily add attributes on the nodes either to all instances or to an individual instance
		#find node to add attribute to
		#add attribute
		self.key=value
	end

	def add_funding_source(source)
		#connect to source (dwolla) via token
		#pull amount
		#add to account balance
	end

	def add_endowment( donor_id, endowment_id, amount )

		#add the donor as connected to endowment

                # Look up the endowment by function argument
                @endowment_node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)

                # Look up the donor by session var donor ID
                @node = Neography::Node.find(ID_INDEX, ID_INDEX, donor_id)

                # Relate the donor *to* the endowment
                donor_rel = @node.outgoing(ENDOWMENT_DONOR_REL) << @endowment_node
		donor_rel.amount = amount

		# Still to do: schedule payment
		# social hooks for tweet/post/pinterest based on donor preferences
	end

	def remove_endowment( donor_id, endowment_id )

		# Donor no longer wants to contribute to endowment, remove connection
		@endowment_node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
                @node = Neography::Node.find(ID_INDEX, ID_INDEX, donor_id)

                @neo = Neography::Rest.new

                # Find relatioships between the two nodes of constant type (from g2g-config.rb)
                rels = @neo.get_node_relationships_to(@endowment_node, @node, "in", ENDOWMENT_DONOR_REL)

                # Should be only one - delete all
                rels.each { |rel_id| @neo.delete_relationship(rel_id) }

        end


	def endowments_contributed_to()
		#return list of all endowments donor contributes to
	end

	def total_funds()
		#return total funds across all merchant processors and investment funds
	end

	def donations(start_date=nil, end_date=nil, source=nil)
		# return total donations between periods
		# possibly filter by source (dwolla, paypal, etc)
	end



end #Donor class




