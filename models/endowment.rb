=begin
class Endowment
#may not need following line if we dont use datamapper, which makes a certain amount of sense
#include DataMapper::Resource 
#has n : donors, required: false

#this is like the charity package of the StautnonLocalPackage, including charities:TiesForHomelessGuys
#and SPCA...... also, need better name for this (givdowments? etc)

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
