class Endowment
#may not need following line if we dont use datamapper, which makes a certain amount of sense
#include DataMapper::Resource 
#has n : donors, required: false

#this is like the charity package of the StautnonLocalPackage, including charities:TiesForHomelessGuys
#and SPCA...... also, need better name for this (givdowments? etc)


# This code does not work -MPB

def create_endowment(name, amount, frequency)

        endowment_node = Neography::Node.create(
                "name" => name,
                "amount" => amount,  # 5   dollars
                "frequency" => frequency # per   month
        )

        # Add this node to the package name index for easy retrieval using name
        endowment_node.add_to_index(ENDOWMENT_NAME_INDEX, "name", data["name"])

        # Look up the Donor owner's / endowment creator's node by email
        owner_donor = Neography::Node.find(DONOR_EMAIL_INDEX, "email", email) # could also use any other indexed value -- maybe access token?

        # Relate the donor to the endowment
        owner_donor.outgoing(ENDOWMENT_OWNER_REL) << endowment_node



        # Look up the Investment fund's node
        investment_fund_node = Neography::Node.find(TYPE_INDEX, TYPE_INDEX, INVESTMENT_FUND_TYPE) # We need a primary key for investment funds

        # Relate the endowment to the investment fund
        investment_rel = endowment_node.outgoing(ENDOWMENT_INVESTMENT_REL) << investment_fund_node
        investment_rel.percent = 100;



        # Now we need to add a relationship for each charity

        # ... to be continued -MPB


end

end

=begin
property :creator # the donor who created this

def add_donor(donor)
	#add the donor to the donors
end

def remove_donor(donor)
	#remove the donor
end

def add_fund
	#add an investment fund
end

def remove_fund
	#remove fund from package
end


def add_charity(charity)
	#needs check for authorized user to change the package/endowment
	#if authorized, change the package/endowment
end

def remove_charity(charity)
	#check for authorized user to change the package/endowment (i.e., user who created it)
	#remove the charity
end

def fork_endowment(forker)
	# Used when a donor changes a package to which there are multiple subscribers
	# Best solution: Donors have preference for what to do when the package changes (set upon signup)
	# “Ask me (Allow changes if no answer)”, “Ask me (no if no answer)”, “Always allow”, “Discard changes”
# All “Allow” donors participate in the endowment where the changes occur
# All “Discard” donors participate in the endowment where the changes do not occur
end



end
=end
