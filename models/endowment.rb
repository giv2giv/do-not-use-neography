load 'lib/functions.rb'
require 'bigdecimal'

class Endowment

#this is like the charity endowment of the StautnonLocalPackage, including charities:TiesForHomelessGuys
#and SPCA...... also, need better name for this (givdowments? etc)

	attr_accessor :node

# This code is untested -MPB

	def self.create(creator_id, name, amount, frequency)

        	@node = Neography::Node.create(
			"id" => generate_unique_id(),
                	"name" => name,
                	"amount" => amount,  # 5   dollars
                	"frequency" => frequency # per   month
        	)
	
        	# Add this node to the endowment indices for easy retrieval
        	@node.add_to_index(ENDOWMENT_NAME_INDEX, ENDOWMENT_NAME_INDEX, name)
        	@node.add_to_index(ID_INDEX, ID_INDEX, @node.id)
	
        	# Add this node to the type index for easy retrieval of all endowments
        	@node.add_to_index(TYPE_INDEX, TYPE_INDEX, ENDOWMENT_TYPE)
	
        	# Look up the endowment creator's node by id 
        	creator_donor = Neography::Node.find(ID_INDEX, ID_INDEX, creator_id)
	
        	# Relate the donor to the endowment
        	creator_donor.outgoing(ENDOWMENT_CREATOR) << @node

		# Create the initial endowment share price node
		@share_node = Neography::Node.create(
			"id" => generate_unique_id(),
			"share_price" => "0.01",
			"shares_outstanding" => "0",
			"current_value" => "0",
		)
        	@share_node.add_to_index(ID_INDEX, ID_INDEX, @share_node.id)

		# Add share_node to SHARE_INDEX to allow share info lookup using endowment_id (@node.id) and date
        	@share_node.add_to_index(SHARE_INDEX, @node.id, Date.today.to_s())

	end

	def self.add_investment_fund( endowment_id )
	
        	# Look up the (only) Investment fund's node
		# This will need to change when we have more than one fund
        	investment_fund_node = Neography::Node.find(TYPE_INDEX, TYPE_INDEX, INVESTMENT_FUND_TYPE)

	
		# Look up the endowment by function argument
		@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)

        	# Relate the endowment to the investment fund
        	investment_rel = @node.outgoing(ENDOWMENT_INVESTMENT) << investment_fund_node
        	investment_rel.percent = 100;

	end

	def self.add_charity( endowment_id, charity_id )
	
		# Look up the endowment by function argument
        	@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
	
		# Look up the charity by function argument
        	charity_node = Neography::Node.find(ID_INDEX, ID_INDEX, charity_id)
	
		# Relate the endowment *to* the charity
        	charity_rel = @node.outgoing(ENDOWMENT_GRANTS) << charity_node
	
	end

	def self.remove_charity( endowment_id, charity_id )

        	@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
        	@charity_node = Neography::Node.find(ID_INDEX, ID_INDEX, charity_id)

		@neo = Neography::Rest.new

		# Find relatioships between the two nodes of constant type (from g2g-config.rb)
		rels = @neo.get_node_relationships_to(@node, @charity_node, "in", ENDOWMENT_GRANTS) 

		# Should be only one - delete all
		rels.each { |rel_id| @neo.delete_relationship(rel_id) }

	end

	def self.find_by_id( endowment_id )
		begin
			@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
                	rescue Neography::NeographyError => err # Don't throw the error
                end
	end

	def self.delete( endowment_id )
		# This needs further consideration. Should mark as inactive rather than delete if already has funds, etc
		@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
                @node.remove_node_from_index()
                @node.del
	end


	def self.get_share_info( endowment_id, date=nil)

                # if date is nil, fetch today's share price
		date ||= Date.today.to_s()

                @share_node = Neography::Node.find(SHARE_INDEX, endowment_id, date)

		# share node has share_price, shares_outstanding, endowment_value

        end
=begin
	def self.buy_fund( endowment_id, transaction_id, fund_id, date, amount ) # Called when funds moved from dwolla/paypal to tradeking

		@node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )
		@fund_node = Neography::Node.find( ID_INDEX, ID_INDEX, fund_id )

        	fund_rel = @node.outgoing(BUYS) << @fund_node	# Create a new relationship
		fund_rel.transaction_id = transaction_id # Set relationship properties
		fund_rel.date = date
		fund_rel.amount = amount

	end

	def self.sell_fund( endowment_id, transaction_id, fund_id, date, amount ) # Called when funds moved from dwolla/paypal to tradeking

                @node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )
                @fund_node = Neography::Node.find( ID_INDEX, ID_INDEX, fund_id )

                fund_rel = @fund_node.outgoing(SELLS) << @node   # Create a new relationship from fund to endowment
                fund_rel.transaction_id = transaction_id # Set relationship properties
                fund_rel.date = date
                fund_rel.amount = amount

        end
	def self.grant_failed( ) # called by Dwolla upon failed grant out to a charity (maybe they never accepted funds?)
		# Should we say 'Contact your charity!' ? What if amount is small?
	end
=end



	def self.investment_fee( endowment_id, transaction_id, fund_id, date, amount )

		@node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )
                @fund_node = Neography::Node.find( ID_INDEX, ID_INDEX, fund_id )

                investment_rel = @fund_node.outgoing(INVESTMENT_FEE) << @node   # Create a new relationship from fund to endowment
                investment_rel.transaction_id = transaction_id # Set relationship properties
                investment_rel.date = date
                investment_rel.amount = amount

	end

	def self.processor_fee( endowment_id, transaction_id, fee )

                @node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )
                @processor_node = fetch_processor_node() # from lib/functions.rb

                processor_rel = @node.outgoing(PROCESSOR_FEE) << @processor_node   # Create a new relationship from endowment to processor
                processor_rel.transaction_id = transaction_id # Set relationship properties
                processor_rel.fee = fee

        end

	def self.sponsor_fee( endowment_id, transaction_id, date, amount )

                @node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )
		@sponsor_node = fetch_sponsor_organization_node() # from lib/functions.rb

                fee_rel = @node.outgoing(PROCESSOR_FEE) << @sponsor_node   # Create a new relationship from endowment to sponsor
                fee_rel.transaction_id = transaction_id # Set relationship properties
                fee_rel.date = date
                fee_rel.amount = amount

	end




	def self.nightly_donations_to_shares( endowment_id )

		# Look up the endowment node
		@node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )

		# Look up endowment share_info in index
		share_info = self.get_share_info( endowment_id, Date.yesterday.to_s() )

		# Always use BigDecimal 

		shares_outstanding = BigDecimal( share_info.shares_outstanding )
		current_value = BigDecimal( share_info.current_value )

		# Find all COMPLETED in to endowment that occurred yesterday

                donation_results = Neography::Rest.new.execute_query("START me = node(#{@node.neo_id})
                        MATCH (donor)->[scheduled#{SCHEDULED}]->(donation)-[completed#{COMPLETED}]->(me)
                        WHERE donation.date_completed='#{Date.yesterday}'
                        RETURN donor.id AS donor_id, donation.id AS donation_id, donation.amount_completed")
                
                array_of_hashes = donation_results["data"].map {|row| Hash[*donation_results["columns"].zip(row).flatten] }
                donations = array_of_hashes.map{|m| OpenStruct.new(m)}

                # Now we should have donation.donor_id


		donations.each do |donation|

			# shares_purchased = amount_completed / share_price
			amount = BigDecimal( donation.amount_completed )
			share_price = BigDecimal( share_info.share_price )

			shares_purchased = amount / share_price

			# Record the shares_purchased in the donation node
			donation_node = Neography::Node.find( ID_INDEX, ID_INDEX, donation.donation_id )
			donation_node.shares_purchased = shares_purchased.to_s()

			
			# TODO how do we easily retrieve total endowment shares by donor? sum(donation_nodes.shares_purchased) - sum(grant_nodes.shares_sold) ? Seems cumbersome
			# We may be better off using a donor-[DONOR_ADVISED]->endowment relationship where DONOR_ADVISED.total_shares is updated on each donation/grant

			current_value += amount
			shares_outstanding += shares_purchased

		end



		# Now do the scheduled grants out to charities

		# This is all kinds of wrong

=begin
		grants = @node.outgoing(SCHEDULED).filter("position.lastRelationship().getProperty('date') == '#{Date.yesterday}';")

		grants.each do |grant_node|

			# shares_purchased = COMPLETED.amount / share_price
                        amount = BigDecimal( grant_node.amount_completed )
                        share_price = BigDecimal( share_info.share_price )

                        shares_sold = amount / share_price
                        grant_node.shares_sold = shares_sold.to_s()

                        current_value -= amount
                        shares_outstanding -= shares_sold
		end
=end




		# Now compute the new share price; current_value and shares_outstanding are already BigDecimal
		share_price = current_value / shares_outstanding

		# Now create a new share_node for today and index it
		@share_node = Neography::Node.create(
                        "id" => generate_unique_id(),
                        "share_price" => share_price,
                        "shares_outstanding" => shares_oustanding.to_s(),
                        "current_value" => current_value.to_s()
                )
                @share_node.add_to_index(ID_INDEX, ID_INDEX, @share_node.id)

                # Add share_node to SHARE_INDEX to allow share info lookup using endowment_id (@node.id) and date
                @share_node.add_to_index(SHARE_INDEX, @node.id, Date.today.to_s())

	end



=begin

	#if authorized, change the endowment/endowment
end

def remove_charity(charity)
	#check for authorized user to change the endowment/endowment (i.e., user who created it)
	#remove the charity
end

def fork_endowment(forker)
	# Used when a donor changes a endowment to which there are multiple subscribers
	# Best solution: Donors have preference for what to do when the endowment changes (set upon signup)
	# “Ask me (Allow changes if no answer)”, “Ask me (no if no answer)”, “Always allow”, “Discard changes”
# All “Allow” donors participate in the endowment where the changes occur
# All “Discard” donors participate in the endowment where the changes do not occur
end


=end

end # End of class
