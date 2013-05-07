
def record_tradeking_transfer_from_dwolla_to_tradeking() 
	# Runs nightly

	# Polls tradeking.com API for incoming transfers from Dwolla initiated by giv2giv admin at tradeking.com
	# steps: record transfer per endowment using Endowment.buy()

end


def generate_grant( date )
	# generate excel of grant advice from donors
	# Each endowment's charity gets: { share_info.current_value * 1.5% / num_charities }
	# columns: donor_id, endowment_id, endowment_name, charity_id, charity_name, amount
end


def prepare_grants( excel_grant_spreadsheet )
	# accepts excel of giv2giv's grant committee decision
	# sells/subtracts donors' shares of endowment
	# update endowment shares_outstanding
	# spits out aggregate amount to transfer TradeKing to Dwolla
	# giv2giv admin transfers aggreate amount from TradeKing to Dwolla using tradeking.com
end

def schedule_grants( excel_grant_spreadsheet )
	# runs nightly
	# Polls tradeking.com API for outgoing transfers from TradeKing to Dwolla initiated during prepare_grants() by giv2giv admin

	# transfer amount should match excel_grant_spreadsheet.total

	# Aggregate grants per charity
	# Endowment.grant() should schedule Dwolla transfers from giv2giv to charity
	# 	make "GRANT" relationship from endowment to charity with transaction_id, request_date, amount
	# 	make "THANKS" relationship from charity to donor with transaction_id, date, their portion of amount
	# send social notifications
end


def record_grant( transaction_id )
	# change grant_requested to grant_complete for each charity
	# add completion_date to relationship
end
