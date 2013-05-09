

load 'lib/functions.rb'

class Grant

	attr_accessor :node


	def generate_grant( date )
        	# generate excel of grant advice from donors
        	# Each endowment's charity gets: { share_info.current_value * 1.5% / num_charities }
        	# columns: donor_id, endowment_id, endowment_name, charity_id, charity_name, amount
		# Outputs excel for off-line review, changes and approval
	end


	def prepare_grants( excel_grant_spreadsheet )
        	# accepts excel of giv2giv's grant committee decisions
        	# sells/subtracts donors' shares of endowment
        	# update endowment shares_outstanding
        	# spits out aggregate amount to transfer from etrade to Dwolla
        	# giv2giv admin transfers aggreate amount from etrade to Dwolla using dwolla
	end

	def schedule_grants ( excel_grant_spreadsheet )
        	# runs nightly
        	# Polls etrade API for outgoing transfers from etrade to Dwolla initiated during prepare_grants() by giv2giv admin
	
        	# transfer amount should match excel_grant_spreadsheet.total
	
        	# Aggregate grants per charity
        	# Schedule aggregated Dwolla transfers from giv2giv to charity
        	#       make "GRANT" nodes like Endowment-(scheduled)->Grant-(:completed)->Charity with transaction_id, dates, amounts
        	#       make "THANKS" relationship from charity to donor with transaction_id, date, their portion of amount ?
        	# send social notifications
	end


	def record_grant( transaction_id )
        	# change grant_scheduled to grant_complete for each charity
        	# add completion_date to grant node
	end




end # end class
