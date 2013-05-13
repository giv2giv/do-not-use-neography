

load 'lib/functions.rb'

class Donation

  # attr_accessor :node
  attr_accessor trasaction_id
  attr_accessor date
  attr_accessor amount
  attr_accessor is_scheduled
  node_accessor donor
  node_accessor endowment


  def initialize(donor, endowment, amount)
    @date = new()
    @amount = amount
    @donor       = donor
    @endowment   = endowment
  end
  
  def schedule_donation()
    @trasaction_id = Dwolla ....
    add_to_index DONATION_INDEX, :transaction_id
  end

  def complete_donation()
  end




	def self.schedule_donation( donor_id, endowment_id, amount )

                # Called upon adding a Dwolla schedule for donation


                @node = Neography::Node.find(ID_INDEX, ID_INDEX, donor_id)

                endowment_node = Neography::Node.find(ID_INDEX, ID_INDEX, endowment_id)




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
                donation_node.amount_scheduled = amount

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

		# Share purchases are recorded nightly to avoid collisions

        end

end # end class
