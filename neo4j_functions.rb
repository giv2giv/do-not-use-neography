require 'rubygems'
require 'bundler/setup'
require 'neo4j'
require 'awesome_print'


# rvm install jruby
# rvm use jruby
# bundle


# All variables below are defined to avoid Ruby scoping hell inside the transaction blocks

$TRANSACTION_FEE = 0.25

def finish_transaction
  return unless @tx
  @tx.success
  @tx.finish
  @tx = nil
end

def start_transaction
  finish_transaction if @tx
  @tx = Neo4j::Transaction.new
end

def create_donor(name) # Expand to include other variables
	start_transaction
		new_donor = Neo4j::Node.new(:name => name)
	finish_transaction
	return new_donor 
end

def create_charity(name) # Expand to include other variables
	start_transaction
		new_charity = Neo4j::Node.new(:name => name)
	finish_transaction
	return new_charity
end

def attach_donor_to_endowment(donor, endowment, amount)
	start_transaction
		Neo4j::Relationship.new(:DONATES_IN, donor, endowment)[:amount] = amount
	finish_transaction
end


def donor_contributes_to_endowment(donor, endowment, amount)
	start_transaction

		# The funds transfer tracking
        	Neo4j::Relationship.new(:TRANSACTS_IN, donor, endowment)[:amount] = amount

		if amount > 10 # Dwolla has to get their $.25 for anything over $10
        		Neo4j::Relationship.new(:PAYS_TRANSACTION_FEE, endowment, @transaction_processor)[:amount] = $TRANSACTION_FEE 
		end

	finish_transaction
end

def adjust_investment_fund(fund, amount_for_each)
	# Find all charities that donate out to this fund, credit each with amount_for_each
	start_transaction
		fund.incoming(:DONATES_OUT).each{|endowment| Neo4j::Relationship.new(:RETURNS, fund, endowment)[:amount]=amount_for_each}
	finish_transaction
end

# Create basic nodes

	# Donors, our merry band of heroes
	@michael = create_donor('Michael')
	@dan = create_donor('Dan')
	@josh = create_donor('Josh')

	# Charities
	@habitat = create_charity('Habitat for Humanity')
	@doctors = create_charity('Doctors without Borders')
	@amnesty = create_charity('Amnesty International')
	@peta = create_charity('PETA')

start_transaction
	# giv2giv entity
        @giv2giv = Neo4j::Node.new(:name => 'giv2giv Incorporated')

	# Investment fund
	@investment_fund = Neo4j::Node.new(:name => 'giv2giv Green Energy Fund A')

	# Merchange processor
	@transaction_processor = Neo4j::Node.new(:name => 'Dwolla')
finish_transaction


# Michael creates an endowment
start_transaction
	@michael_endowment = Neo4j::Node.new(:name => 'Amnesty for Habitat Doctors', :minimum_amount => 10)

	# Make Michael the endowment owner
	Neo4j::Relationship.new(:OWNS, @michael, @michael_endowment)

	# Michael defines the preferred investment fund(s)
	Neo4j::Relationship.new(:INVESTS_IN, @michael_endowment, @investment_fund)[:percent] = 100

	# Michael defines the charities to receive payments from the endowment
	Neo4j::Relationship.new(:DONATES_OUT, @michael_endowment, @habitat)[:percent] = 50
	Neo4j::Relationship.new(:DONATES_OUT, @michael_endowment, @doctors)[:percent] = 50
	Neo4j::Relationship.new(:DONATES_OUT, @michael_endowment, @amnesty)[:percent] = 50
finish_transaction

# Dan creates an endowment
start_transaction
	@dan_endowment = Neo4j::Node.new(:name => 'PETA Doctors', :minimum_amount => 15)

	# Make Dan the endowment owner
	Neo4j::Relationship.new(:OWNS, @dan, @dan_endowment)

	# Dan defines the preferred investment fund(s)
	Neo4j::Relationship.new(:INVESTS_IN, @dan_endowment, @investment_fund)[:percent] = 100

	# Dan defines the charities to receive payments from the endowment
	Neo4j::Relationship.new(:DONATES_OUT, @dan_endowment, @habitat)[:percent] = 50
	Neo4j::Relationship.new(:DONATES_OUT, @dan_endowment, @peta)[:percent] = 50
finish_transaction


# Now, set which donors will eventually contribute to which packages
# Owners must contribute to their own packages
attach_donor_to_endowment(@michael, @michael_endowment, 20)
attach_donor_to_endowment(@dan, @dan_endowment, 25)

# Other donors want to contribute to the endowments too
attach_donor_to_endowment(@josh, @michael_endowment, 10)
attach_donor_to_endowment(@josh, @dan_endowment, 15)



# Now let's make some actual transactions - this signifies the movement of money from Michael, Dan and Josh into the two endowments

# Michael makes a contribution to his endowment from Dwolla, and pays the fee
donor_contributes_to_endowment(@michael, @michael_endowment, 50)
# Dan makes a contribution to his endowment from Dwolla, and pays the fee
donor_contributes_to_endowment(@dan, @dan_endowment, 55)
# Josh contributes to both
donor_contributes_to_endowment(@josh, @michael_endowment, 20)
donor_contributes_to_endowment(@josh, @dan_endowment, 20)

# A month goes by. Please sir, may I have some more?
donor_contributes_to_endowment(@michael, @michael_endowment, 50)
donor_contributes_to_endowment(@dan, @dan_endowment, 55)
donor_contributes_to_endowment(@josh, @michael_endowment, 20)
donor_contributes_to_endowment(@josh, @dan_endowment, 20)


# Stocks are up! Collect $200

adjust_investment_fund(@investment_fund, 200)

# Investment fund manager needs a new boat
start_transaction
	Neo4j::Relationship.new(:PAYS_INVESTMENT_FEE, @michael_endowment, @investment_fund)[:amount] = 50
	Neo4j::Relationship.new(:PAYS_INVESTMENT_FEE, @dan_endowment, @investment_fund)[:amount] = 50
finish_transaction

# A quarter goes by. Let's make a donation out to our charities.
# To do this correctly you would look up the recipient charities and transact 1.25% of the total value, then distribute proportionate to the DONATES_OUT relationship percentage
# I will do it manually with a separate TRANSACTS_OUT relationship for easier MATCHing

start_transaction
	Neo4j::Relationship.new(:TRANSACTS_OUT, @michael_endowment, @habitat)[:amount] = 2 
	Neo4j::Relationship.new(:TRANSACTS_OUT, @michael_endowment, @doctors)[:amount] = 1
	Neo4j::Relationship.new(:TRANSACTS_OUT, @michael_endowment, @amnesty)[:amount] = 1
	Neo4j::Relationship.new(:TRANSACTS_OUT, @dan_endowment, @peta)[:amount] = 3
	Neo4j::Relationship.new(:TRANSACTS_OUT, @dan_endowment, @doctors)[:amount] = 2

	# Dwolla does all transaction < $.25 for free, so no PAYS_TRANSACTION_FEE relationship

	# giv2giv needs to pay the light bill
	Neo4j::Relationship.new(:PAYS_OVERHEAD_FEE, @dan_endowment, @giv2giv)[:amount] = 0.23
	Neo4j::Relationship.new(:PAYS_OVERHEAD_FEE, @michael_endowment, @giv2giv)[:amount] = 0.23
finish_transaction



# Let's put our cypher into functions and output some data

def charities_contributed_to(node)

	node_id = node.neo_id().to_i

	# Specify relationship type between donors, endowments and charities.
	Neo4j.query("START me = node({node_id})
        MATCH (me)-[:DONATES_IN]->(endowment)-[:DONATES_OUT]->(charities_supported)
	RETURN charities_supported.name", {:node_id => node_id})["data"]

	# More generic MATCH usage: (a)--(b)--(c) RETURN c
end

def transactions_in(node)
	node_id = node.neo_id().to_i
	p node_id # prints 356

	#node.outging(:TRANSACTS_IN).each{|endowment| Neo4j::Relationship.new(:RETURNS, fund, endowment)[:amount]=amount_for_each}

        Neo4j._query("START me = node({node_id})
        MATCH (me)-[transaction_in:TRANSACTS_IN]->(endowment)
        RETURN SUM(transaction_in.amount)", {:node_id => node_id})["data"]
end

def transactions_out(node)
	node_id = node.neo_id().to_i

        Neo4j.query("START me = node({node_id})
        MATCH (me)-[transaction_out:TRANSACTS_OUT]->(charity)
        RETURN SUM(transaction_out.amount)", {:node_id => node_id})["data"]
end

def endowment_value(node)
	node_id = node.neo_id().to_i

        @neo.execute_query("START me = node({node_id})

        MATCH (donor)-[transaction_in:TRANSACTS_IN]->(me)
	WITH me, SUM(transaction_in.amount) AS Total_In

        MATCH (me)-[transaction_out:TRANSACTS_OUT]->(charity)
	WITH SUM(transaction_out.amount) AS Total_Out, Total_In

        RETURN Total_In-Total_Out", {:node_id => node_id})["data"]
end



puts ""
puts "In two months, Michael contributed #{transactions_in(@michael)} into his own endowment"
puts "In two months, Dan contributed #{transactions_in(@dan)} into his own endowment"
puts "In two months, Josh contributed #{transactions_in(@josh)} into Michael's and Dan's endowments"
puts ""

=begin
puts "After two months, Michael's endownment has paid out #{transactions_out(michael_endowment)} to his charities"
puts "After two months, Dan's endownment has paid out #{transactions_out(dan_endowment)} to his charities"
puts ""
puts "After payouts and fees, Michael's endowment holds #{endowment_value(michael_endowment)}"
puts "After payouts and fees, Dan's endowment holds #{endowment_value(dan_endowment)}"
puts ""
puts "Through all his endowments, Michael contributes to the following charities: #{charities_contributed_to(@michael).join(', ')}"
puts "Through all his endowments, Dan contributes to the following charities: #{charities_contributed_to(@dan).join(', ')}"
puts "Through all his endowments, Josh contributes to the following charities: #{charities_contributed_to(@josh).join(', ')}"
puts ""
=end
