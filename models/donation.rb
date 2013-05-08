
	def self.request_donation( donor_id, endowment_id, amount )

                # Called upon adding a Dwolla request for donation

                # DAN do your magic here
                # transaction_id = Dwolla.request_funds(tokens, donors, amounts)

                @node = Neography::Node.find(ID_INDEX, ID_INDEX, donor_id)

                endowment_node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)

                # Create a donation node
                donation_node = Neography::Node.create( "id" => generate_unique_id(), "transaction_id"=>transaction_id)
                donation_node.request_date = Date.today.to_s()
                donation_node.add_to_index(DONATION_INDEX, donor_id, transaction_id)

                # Create a request relationship from donor to donation
                request_rel = @node.outgoing(REQUESTS_DONATION) << donation_node

                # Create a pending relationship from donation to Endowment
                pending_rel = donation_node.outgoing(PENDING_DONATION) << endowment_node
                pending_rel.amount = amount

        end

	def self.complete_donation( donor_id, endowment_id, transaction_id, date, amount, fee=nil)

                # Called by Dwolla webhook upon successful donation
                # Donor completes donation into a giv2giv mini-endowment. Create a relationship between donor and endowment, storing key/value data pairs in the relationship

                endowment_node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)
                # Find donation node
                donation_node = Neography::Node.find(DONATION_INDEX, donor_id, transaction_id)

                processor_node = Neography::Node.find(TYPE_INDEX, TYPE_INDEX, PROCESSOR_TYPE)

                if fee
                        fee_rel = donation_node.outgoing(PROCESSOR_FEE) << processor_node
                        fee_rel.amount = fee
                end

                # Create a new outgoing relation from the donor *to* the endowment to record the transaction
                completed_rel = donation_node.outgoing(COMPLETED_DONATION) << endowment_node
                completed_rel.date = date
                completed_rel.amount = amount


                # get share_info for the endowment to get share_price, shares_oustanding, current_value
                share_info = Endowment.get_share_info( endowment_id, Date.today.to_s())

                # Always use BigDecimal
                share_price = BigDecimal(share_info.share_price) # get_share_price returns a string
                amount = BigDecimal(amount) # amount donated

                shares_purchased = ( amount / share_price ) # How many shares were purchased?

                donation_node.share_price = share_price.to_s() # Store # of shares for this transaction in the node
                donation_node.shares_purchased = shares_purchased.to_s() # Store # of shares for this transaction in the node

                # Store new endowment shares_outstanding in the endowment's share_info node
                share_info.shares_outstanding = (BigDecimal(share_info.shares_outstanding) + shares_purchased).to_s()

                # Store new endowment current_value in the endowment's share_info node
                share_info.current_value = (BigDecimal(share_info.current_value) + amount).to_s()

        end
