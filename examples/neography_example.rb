require 'rubygems'
require 'neography' #neo4j access library - https://github.com/maxdemarzi/neography/

load '../config/g2g-config.rb'

@neo = Neography::Rest.new

# Create basic nodes

# giv2giv entity
giv2giv = @neo.create_node("name" => "giv2giv Incorporated")

# Donors, our merry band of heroes
michael = @neo.create_node("name" => "Michael")
dan = @neo.create_node("name" => "Dan")
josh = @neo.create_node("name" => "Josh")

# Charities
habitat = @neo.create_node("name" => "Habitat for Humanity")
doctors = @neo.create_node("name" => "Doctors without Borders")
amnesty = @neo.create_node("name" => "Amnesty International")
peta = @neo.create_node("name" => "PETA")

# Investment fund
investment_fund = @neo.create_node("name" => "giv2giv Green Energy Fund A")

# Merchange processor
transaction_processor = @neo.create_node("name" => "Dwolla")


# Our heroes create some endowments


# Michael creates an endowment
michael_endowment = @neo.create_node("name" => "Amnesty for Habitat Doctors", "minimum_amount" => 10)

# Make Michael the endowment owner
@neo.create_relationship("OWNS", michael, michael_endowment)


# Michael defines the preferred investment fund(s)
@neo.create_relationship("INVESTS_IN", michael_endowment, investment_fund)

# Michael defines the charities to receive payments from the endowment
@neo.create_relationship("DONATES_OUT", michael_endowment, habitat, {"percent"=>50})
@neo.create_relationship("DONATES_OUT", michael_endowment, doctors, {"percent"=>40})
@neo.create_relationship("DONATES_OUT", michael_endowment, amnesty, {"percent"=>10})


# Dan creates a package

dan_endowment = @neo.create_node("name" => "PETA Doctors", "minimum_amount" => 15)

# Make Dan the endowment owner
@neo.create_relationship("OWNS", dan, dan_endowment)


# Dan defines the preferred investment fund(s)
@neo.create_relationship("INVESTS_IN", dan_endowment, investment_fund)

# Dan defines the charities to receive payments from the endowment
@neo.create_relationship("DONATES_OUT", dan_endowment, habitat, {"percent"=>50})
@neo.create_relationship("DONATES_OUT", dan_endowment, peta, {"percent"=>50})


# Now, set which donors will eventually contribute to which packages

# Owners must contribute to their own packages
@neo.create_relationship("DONATES_IN", michael, michael_endowment, {"amount"=>20})
@neo.create_relationship("DONATES_IN", dan, dan_endowment, {"amount"=>25})


# Other donors want to contribute to the endowments too
@neo.create_relationship("DONATES_IN", josh, michael_endowment, {"amount"=>10})
@neo.create_relationship("DONATES_IN", josh, dan_endowment, {"amount"=>15})






# Now let's make some actual transactions - this signifies the movement of money from Michael, Dan and Josh into the two endowments
@neo.create_relationship("TRANSACTS_IN", michael, michael_endowment, {"amount"=>50})
@neo.create_relationship("TRANSACTS_IN", dan, dan_endowment, {"amount"=>55})
@neo.create_relationship("TRANSACTS_IN", josh, michael_endowment, {"amount"=>20})
@neo.create_relationship("TRANSACTS_IN", josh, dan_endowment, {"amount"=>25})

# Dwolla has to get their $.25 for anything over $10
#@neo.create_relationship("PAYS_TRANSACTION_FEE", michael_endowment, transaction_processor, {"amount"=>0.25})
#@neo.create_relationship("PAYS_TRANSACTION_FEE", dan_endowment, transaction_processor, {"amount"=>0.25})

# A month goes by. Please sir, may I have some more?
@neo.create_relationship("TRANSACTS_IN", michael, michael_endowment, {"amount"=>50})
@neo.create_relationship("TRANSACTS_IN", dan, dan_endowment, {"amount"=>55})
@neo.create_relationship("TRANSACTS_IN", josh, michael_endowment, {"amount"=>20})
@neo.create_relationship("TRANSACTS_IN", josh, dan_endowment, {"amount"=>25})

# Dwolla has to get their $.25 for anything over $10
@neo.create_relationship("PAYS_TRANSACTION_FEE", michael_endowment, transaction_processor, {"amount"=>0.25})
@neo.create_relationship("PAYS_TRANSACTION_FEE", dan_endowment, transaction_processor, {"amount"=>0.25})

# Stocks are up! Collect $200
@neo.create_relationship("RETURNS", investment_fund, michael_endowment, {"amount"=>200})
@neo.create_relationship("RETURNS", investment_fund, dan_endowment, {"amount"=>200})

# Investment fund manager needs a new boat
@neo.create_relationship("PAYS_INVESTMENT_FEE", michael_endowment, investment_fund, {"amount"=>50})
@neo.create_relationship("PAYS_INVESTMENT_FEE", dan_endowment, investment_fund, {"amount"=>50})


# A quarter goes by. Let's make a donation out to our charities.
# To do this correctly you would look up the recipient charities and transact 1.25% of the total value, then distribute proportionate to the DONATES_OUT relationship percentage
# I will do it manually with a separate TRANSACTS_OUT relationship for easier MATCHing

@neo.create_relationship("TRANSACTS_OUT", michael_endowment, habitat, {"amount"=>2}) 
@neo.create_relationship("TRANSACTS_OUT", michael_endowment, doctors, {"amount"=>1}) 
@neo.create_relationship("TRANSACTS_OUT", michael_endowment, amnesty, {"amount"=>1}) 
@neo.create_relationship("TRANSACTS_OUT", dan_endowment, peta, {"amount"=>3})
@neo.create_relationship("TRANSACTS_OUT", dan_endowment, doctors, {"amount"=>2})

# Dwolla does all transaction < $.25 for free, so no PAYS_TRANSACTION_FEE

# giv2giv needs to pay the light bill
@neo.create_relationship("PAYS_OVERHEAD_FEE", dan_endowment, giv2giv, {"amount"=>0.23})
@neo.create_relationship("PAYS_OVERHEAD_FEE", michael_endowment, giv2giv, {"amount"=>0.23})




# Let's put our cypher into functions and output some data


def charities_contributed_to(node)
	node_id = node["self"].split('/').last.to_i

	# Specify relationship type between donors, endowments and charities.
	@neo.execute_query("START me = node({node_id})
        MATCH (me)-[:DONATES_IN]->(endowment)-[:DONATES_OUT]->(charities_supported)
	RETURN charities_supported.name", {:node_id => node_id})["data"]

	# More generic MATCH usage: (a)--(b)--(c) RETURN c
end

def transactions_in(node)
        node_id = node["self"].split('/').last.to_i

        @neo.execute_query("START me = node({node_id})
        MATCH (me)-[transaction_in:TRANSACTS_IN]->(endowment)
        RETURN SUM(transaction_in.amount)", {:node_id => node_id})["data"]
end

def transactions_out(node)
        node_id = node["self"].split('/').last.to_i

        @neo.execute_query("START me = node({node_id})
        MATCH (me)-[transaction_out:TRANSACTS_OUT]->(charity)
        RETURN SUM(transaction_out.amount)", {:node_id => node_id})["data"]
end

def endowment_value(node)
	node_id = node["self"].split('/').last.to_i

        @neo.execute_query("START me = node({node_id})

        MATCH (donor)-[transaction_in:TRANSACTS_IN]->(me)
	WITH me, SUM(transaction_in.amount) AS Total_In

        MATCH (me)-[transaction_out:TRANSACTS_OUT]->(charity)
	WITH SUM(transaction_out.amount) AS Total_Out, Total_In

        RETURN Total_In-Total_Out", {:node_id => node_id})["data"]
end


puts ""
puts "In two months, Michael contributed #{transactions_in(michael)} into his own endowment"
puts "In two months, Dan contributed #{transactions_in(dan)} into his own endowment"
puts "In two months, Josh contributed #{transactions_in(josh)} into Michael's and Dan's endowments"
puts ""
puts "After two months, Michael's endownment has paid out #{transactions_out(michael_endowment)} to his charities"
puts "After two months, Dan's endownment has paid out #{transactions_out(dan_endowment)} to his charities"
puts ""
puts "After payouts and fees, Michael's endowment holds #{endowment_value(michael_endowment)}"
puts "After payouts and fees, Dan's endowment holds #{endowment_value(dan_endowment)}"
puts ""
puts "Through all his endowments, Michael contributes to the following charities: #{charities_contributed_to(michael).join(', ')}"
puts "Through all his endowments, Dan contributes to the following charities: #{charities_contributed_to(dan).join(', ')}"
puts "Through all his endowments, Josh contributes to the following charities: #{charities_contributed_to(josh).join(', ')}"
puts ""

