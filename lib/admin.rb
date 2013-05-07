
def schedule_transfer_from_dwolla_to_tradeking() 
	# Runs nightly

	# Steps:  Compute amount, Make transfer, (record transfers per endowment?)

	# Get successful donations today (from neo4j, not dwolla b/c donations will be mingled with other transfers)
	# Schedule Dwolla transfer of aggregate

end

def record_transfer_from_dwolla_to_tradeking() 
	# records transfer from dwolla to tradeking

	# steps: record transfer per endowment using Endowment.buy()
end

def record_transfer_from_dwolla_to_tradeking()
        # records transfer from dwolla to tradeking

        # steps: record transfer per endowment using Endowment.buy()
end


def get_dwolla_balance_required_on_grant_date( date )
	# compute 1.5% of an endowment's share_info current_value
	# use cypher
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
	# transfer aggregate from TradeKing to Dwolla
end

def schedule_grants( excel_grant_spreadsheet )
	# Run upon prepare_grants() transfer complete

	# Aggregates grants per charity
	# Schedules Dwolla transfers from giv2giv to charity
	# Endowment.grant()
	# make "GRANT" relationship from endowment to charity with transaction_id, request_date, amount
	# make "THANKS" relationship from charity to donor with transaction_id, date, their portion of amount

	# send social notifications
end


def record_grant( transaction_id )
	# change grant_requested to grant_complete for each charity
	# add completion_date to relationship
end
