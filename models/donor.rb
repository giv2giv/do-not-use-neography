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

=end

