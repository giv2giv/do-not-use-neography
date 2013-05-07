load 'lib/functions.rb'

class Endowment

#this is like the charity endowment of the StautnonLocalPackage, including charities:TiesForHomelessGuys
#and SPCA...... also, need better name for this (givdowments? etc)

	attr_accessor :node

# This code is untested -MPB

	def self.create(owner_id, name, amount, frequency)

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
	
        	# Look up the Donor owner's / endowment creator's node by id 
        	creator_donor = Neography::Node.find(ID_INDEX, ID_INDEX, creator_id)
	
        	# Relate the donor to the endowment
        	creator_donor.outgoing(ENDOWMENT_CREATOR) << @node

		# Create the initial endowment share price node
		@share_node = Neography::Node.create(
			"id" => generate_unique_id(),
			"share_price" => "0.01",
			"shares_outstanding" => "0",
			"fund_value" => "0",
		)
        	@node.add_to_index(ID_INDEX, ID_INDEX, @share_node.id)

		# Add to SHARE_INDEX to allow share info lookup using endowment_id (@node.id) and date
        	@node.add_to_index(SHARE_INDEX, @node.id, Date.today.to_s())

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

	def self.grant_successful( endowment_id, transaction_id, charity_id, date, amount )

		# This will be called when grant is scheduled out to a charity

		# No need to fiddle w/ shares because shares sold in grant_prepare()

		# Recording a bulk grant from an endowment out to a charity
		@node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )
                @charity_node = Neography::Node.find( ID_INDEX, ID_INDEX, charity_id )

		grant_rel = @node.outgoing(GRANTS) << @charity_node # Create a new relationship from endowment to charity
		grant_rel.transaction_id = transaction_id # Set relationship properties
                grant_rel.date = date
                grant_rel.amount = amount

	end

	def self.pay_investment_fee( endowment_id, transaction_id, fund_id, date, amount )

		@node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )
                @fund_node = Neography::Node.find( ID_INDEX, ID_INDEX, fund_id )

                investment_rel = @fund_node.outgoing(INVESTMENT_FEE) << @node   # Create a new relationship from fund to endowment
                investment_rel.transaction_id = transaction_id # Set relationship properties
                investment_rel.date = date
                investment_rel.amount = amount

	end

	def self.processor_fee( endowment_id, transaction_id, processor_id, date, amount )

                @node = Neography::Node.find( ID_INDEX, ID_INDEX, endowment_id )
                @processor_node = Neography::Node.find( ID_INDEX, ID_INDEX, processor_id )

                processor_rel = @node.outgoing(PROCESSOR_FEE) << @processor_node   # Create a new relationship from endowment to processor
                processor_rel.transaction_id = transaction_id # Set relationship properties
                processor_rel.date = date
                processor_rel.amount = amount

        end

	def self.sponsor_fee( endowment, transaction_id, date, amount )

		@node = fetch_sponsor_organization_node() # from lib/functions.rb
                @processor_node = Neography::Node.find( ID_INDEX, ID_INDEX, processor_id )

                fund_rel = @node.outgoing(PROCESSOR_FEE) << @processor_node   # Create a new relationship from endowment to sponsor
                fund_rel.transaction_id = transaction_id # Set relationship properties
                fund_rel.date = date
                fund_rel.amount = amount

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
