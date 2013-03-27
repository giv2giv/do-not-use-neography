require 'rubygems'
require 'neography' #neo4j access library - https://github.com/maxdemarzi/neography/

load 'g2g-config.rb'


# Get a new handle to neo4j's RESTful API
@neo = Neography::Rest.new


# record_incoming_donation()
# Called upon successful transfer of funds from a donor to giv2giv for allocation to a specific endowment
def record_incoming_donation(donor, endowment, data)

	# donor, endowment are neo4j nodes
	# data format: Hash["amount" => float, "date" => string, "transaction_id" => string] 

	@neo.create_relationship("DONATES_IN", michael_endowment, investment_fund, data)

	if (data['amount'] > DWOLLA_FEE_THRESHOLD) then

		# record fee amount, date, original transaction_id
		@neo.create_relationship("PAYS_TRANSACTION_FEE", endowment, transaction_processor, {"amount"=>DWOLLA_TRANSACTION_FEE, "date" => data["date"], "transaction_id"=> data['transaction_id']})

	end

end # END record_incoming_donation(donor, endowment, data)


# record_outgoing_grant()
# Called upon successful transfer of funds from an endowment to a specific charity
def record_outgoing_grant (endowment, charity, data)

	# donor, charity are neo4j nodes
	# data format: Hash["amount" => float, "date" => string, "transaction_id" => string] 

	@neo.create_relationship("DONATES_OUT", endowment, charity, data)

end # END record_outgoing_grant (endowment, charity, data)


# record_investment_fee
# Called to record the portion of a periodic investment management fee that should be allocated to a specific endowment
def record_investment_fee(endowment, investment_fund, data)

	# endowment, investment_fund are neo4j nodes
	# data format: Hash["amount" => float, "date" => string]

	@neo.create_relationship("PAYS_INVESTMENT_FEE", endowment, fund, data)

end # END record_investment_fee(endowment, investment_fund, data)


# record_investment_return
# Called to record the portion of a change in investment fund value that should be allocated to a specific endowment
def record_investment_return (endowment, investment_fund, data)

	# endowment, investment_fund are neo4j nodes
	# data format: Hash["amount" => float, "date" => string]
	# Note that amount can be negative

	@neo.create_relationship("INVESTMENT_RETURNS", investment_fund, endowment, data)

end # END record_investment_return (endowment, investment_fund, data)


# record_overhead_fee
# Called to record the portion of a outgoing_grant allocated to giv2giv
def record_overhead_fee (endowment, data)

	# endowment, giv2giv are neo4j nodes
	# data format: Hash["amount" => float, "date" => string, "transaction_id" => string]

	# Fetch the node for the sponsoring organization
	load 'sponsoring_organization.rb'
	giv2giv = fetch_sponsoring_organization_node()

	@neo.create_relationship("PAYS_OVERHEAD_FEE", endowment, giv2giv, data)

end





# Future work: put our cypher into functions and output some data


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

