

load 'lib/functions.rb'

class Donation

	attr_accessor :node

	def self.schedule_donation( donor_id, endowment_id, amount )

                # Called upon adding a Dwolla schedule for donation


                @node = Neography::Node.find(ID_INDEX, ID_INDEX, donor_id)

                endowment_node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)


                # DAN do your magic here
		# transaction_id = Dwolla.schedule_funds(tokens, donors, amounts)

                # Create a donation node
                donation_node = Neography::Node.create( "id" => generate_unique_id(), "transaction_id" => transaction_id)

		# Add which endowment this donation goes to
                donation_node.endowment_id = endowment_id
		
		# Add to index for looking node up by transaction_id
                donation_node.add_to_index(DONATION_INDEX, transaction_id, transaction_id)

                # Create a SCHEDULED relationship from donor to donation
                scheduled_rel = @node.outgoing(SCHEDULED) << donation_node

		# Add date and amount to scheduled relationship
                donation_node.date_scheduled = Date.today.to_s()
                donation_rel.amount_scheduled = amount

        end

	def self.complete_donation( transaction_id, date, amount, fee=nil)

                # Called by Dwolla webhook upon successful donation
                # Donor completes donation into a giv2giv mini-endowment. Create a relationship between donor and endowment, storing key/value data pairs in the relationship

                # Find donation node
                donation_node = Neography::Node.find(DONATION_INDEX, transaction_id, transaction_id)

		# Find endowment node
		endowment_node = Neography::Node.find(ID_INDEX, ID_INDEX, donation_node.endowment_id)

		# Make COMPLETED relationship from donation to endowment
                completed_rel = donation_node.outgoing(COMPLETED) << endowment_node

		# Add clearing date and final amount
		donation_node.date_completed=date
		donation_node.amount_completed = amount

		# If there is a fee, record it
                if fee
			Endowment.fee( endowment_node.id, transaction_id, fee )
                end


        end

end # end class
