load 'lib/functions.rb'

class Endowment
#may not need following line if we dont use datamapper, which makes a certain amount of sense
#include DataMapper::Resource 
#has n : donors, required: false

#this is like the charity endowment of the StautnonLocalPackage, including charities:TiesForHomelessGuys
#and SPCA...... also, need better name for this (givdowments? etc)

	attr_accessor :node

# This code does not work -MPB

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
        	owner_donor = Neography::Node.find(ID_INDEX, ID_INDEX, owner_id)
	
        	# Relate the donor to the endowment
        	owner_donor.outgoing(ENDOWMENT_OWNER_REL) << @node
	
	end

	def self.add_investment_fund( endowment_id )
	
        	# Look up the (only) Investment fund's node
		# This will need to change when we have more than one fund
        	investment_fund_node = Neography::Node.find(TYPE_INDEX, TYPE_INDEX, INVESTMENT_FUND_TYPE)

	
		# Look up the endowment by function argument
		@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)

        	# Relate the endowment to the investment fund
        	investment_rel = @node.outgoing(ENDOWMENT_INVESTMENT_REL) << investment_fund_node
        	investment_rel.percent = 100;

	end

	def self.add_charity( endowment_id, charity_id )
	
		# Look up the endowment by function argument
        	@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
	
		# Look up the charity by function argument
        	charity_node = Neography::Node.find(ID_INDEX, ID_INDEX, charity_id)
	
		# Relate the endowment *to* the charity
        	charity_rel = @node.outgoing(ENDOWMENT_GRANTS_REL) << charity_node
	
	end

	def self.remove_charity( endowment_id, charity_id )

        	@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
        	@charity_node = Neography::Node.find(ID_INDEX, ID_INDEX, charity_id)

		@neo = Neography::Rest.new

		# Find relatioships between the two nodes of constant type (from g2g-config.rb)
		rels = @neo.get_node_relationships_to(@node, @charity_node, "in", ENDOWMENT_GRANTS_REL) 

		# Should be only one - delete all
		rels.each { |rel_id| @neo.delete_relationship(rel_id) }

	end

	def self.find( endowment_id )
		begin
			@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
                	rescue Neography::NeographyError => err # Don't throw the error
                end
	end

	def self.delete( endowment_id )
		# This needs further consideration. Should mark as inactive rather than delete if already has funds, etc
		@node = Neography::Node.find(ID_INDEX, ID_INDEX, id)
                @node.remove_node_from_index()
                @node.del
	end


	def self.add_donor( endowment_id, donor_id )
		#add the donor to the package
	
		# Look up the endowment by function argument
        	@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
	
        	# Look up the donor by session var donor ID
        	donor_node = Neography::Node.find(ID_INDEX, ID_INDEX, session[:id])
	
        	# Relate the donor *to* the endowment
        	donor_rel = donor_node.outgoing(ENDOWMENT_DONOR_REL) << @node
	
	end

	def self.remove_donor( endowment_id, donor_id )

		@node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
                @donor_node = Neography::Node.find(ID_INDEX, ID_INDEX, donor_id)

                @neo = Neography::Rest.new
                
                # Find relatioships between the two nodes of constant type (from g2g-config.rb)
                rels = @neo.get_node_relationships_to(@node, @donor_node, "in", ENDOWMENT_DONOR_REL)

                # Should be only one - delete all
                rels.each { |rel_id| @neo.delete_relationship(rel_id) }

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
