
load 'lib/functions.rb'
require 'bigdecimal'

class Fund

	attr_accessor :node

	def self.create( name ) 

                @node = Neography::Node.create(
                        "id" => generate_unique_id(),
                        "name" => name
                )

		# Create the initial endowment share price node
                @share_node = Neography::Node.create(
                        "id" => generate_unique_id(),
                        "share_price" => "0.01",
                        "shares_outstanding" => "0",
                        "fund_value" => "0",
                )

                @share_node.add_to_index(ID_INDEX, ID_INDEX, @share_node.id) # push node into catch-all ID index

                # Add to SHARE_INDEX to allow share info lookup using fund_id (@node.id) and date
                @share_node.add_to_index(SHARE_INDEX, @node.id, Date.today.to_s())

	end


	def compute_share_price( fund_id )

		# Look up fund node
		@fund_node = Neography::Node.find(ID_INDEX, ID_INDEX, fund_id)


		# Look up share price node from previous day
		@yesterday_node = Neography::Node.find(SHARE_INDEX, fund_id, Date.yesterday)


		# Execute completed BUYs, increasing shares_standing
		# We may need to do this with cypher
		yesterday_buys = @fund_node.incoming(BUYS).filter("position.endNode().getProperty('date') == '#{Date.yesterday}';")

		# Execute completed SELLs, decreasing shares_standing
		yesterday_sells = @fund_node.incoming(SELLS).filter("position.endNode().getProperty('date') == '#{Date.yesterday}';")


                # Always use BigDecimal
                share_price = BigDecimal($yesterday_node.share_price) # get_share_price returns a string

		node_id = @yesterday_node.neo_id

		# Sum across completed buys
        	buy_amount = @neo.execute_query("START me = node({node_id})
        	MATCH (me)-[buys#{COMPLETED}]->(fund)
		WHERE buys.date='#{Date.yesterday}'
        	RETURN SUM(buys.amount)", {:node_id => node_id})["data"]

                shares_purchased = ( amount / share_price ) # How many shares were purchased?

                donation_node.share_price = share_price.to_s() # Store # of shares for this transaction in the node
                donation_node.shares_purchased = shares_purchased.to_s() # Store # of shares for this transaction in the node

                # Store new endowment shares_outstanding in the endowment's share_info node
                share_info.shares_outstanding = (BigDecimal(share_info.shares_outstanding) + shares_purchased).to_s()

                # Store new endowment current_value in the endowment's share_info node
                share_info.current_value = (BigDecimal(share_info.current_value) + amount).to_s()


		@today_node = Neography::Node.create(
                        "id" => generate_unique_id(),
                        "share_price" => "0.01",
                        "shares_outstanding" => "0",
                        "fund_value" => "0",
                )

		# Look up buys / sales

		# Incoming ACH Received's add to shares_outstanding
		# Look up eTrade, find incoming deposits from previous day

		# Outgoing SELL relationships subtract from shares_outstanding

		@buy_nodes = Neography::Node.find(SHARE_INDEX, fund_id, date)

		# Look up appreciation/depreciation
		# Look up total fund value
		

		# Compute new shares outstanding
		# Compute new share price

	end


end # end class
