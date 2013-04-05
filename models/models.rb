=begin

# Not working

class Donor
#may not need following line if we dont use datamapper, which makes a certain amount of sense
#include DataMapper::Resource 

#property :something Serial    # An auto-increment integer key

property :node_id,  Integer
property :created_at, DateTime  # A DateTime, for any date you might like.

property :email,       Text      # A text block, for longer string data.
property :name,      String    # A varchar type string, for short strings

property :address, Text
property :city, Text
property :state,   String
property :zip1,  Integer
property :zip2,  Integer

property :facebook_token, Text, :default=>Null
property :dwolla_token, Text, :default=>Null
property :twitter_token, Text, :default=>Null

	def add_funds(source)
		#connect to source via token
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

class Charity
#may not need following line if we don’t use datamapper, which makes a certain amount of sense
#include DataMapper::Resource 

property :node_id,    Integer    # An auto-increment integer key

property :name,      String    # A varchar type string, for short strings
	property :ein, 	        String    # varchar
	property :address,  String
	property :city,         String
	property :state,       String
	property :zip,          Integer
	property :ntee_common,  String
	property :ntee_core,   String

end

=end
