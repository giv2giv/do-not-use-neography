

def create_donor(data)

	# Create the node
        donor_node = Neography::Node.create(
		"name" => data["name"],
		"email" => data["email"],
		"password" => data["password"]
	)

        # Add this node to the donor email index for easy retrieval using email
        donor_node.add_to_index(DONOR_EMAIL_INDEX, "email", data["email"])

	return donor_node

end


def create_endowment(data)

	endowment_node = Neography::Node.create(
		"name" => data["name"],
		"amount" => data["amount"],  # 5   dollars
		"frequency" => data["frequency"] # per   month
	)

	# Add this node to the package name index for easy retrieval using name
	endowment_node.add_to_index(ENDOWMENT_NAME_INDEX, "name", data["name"])


	# Look up the Donor owner's / endowment creator's node
	owner_node = Neography::Node.find(DONOR_EMAIL_INDEX, "email", data["email"]) # could also use any other indexed value -- maybe access token?

	# Relate the donor to the endowment
	donor_owner.outgoing(ENDOWMENT_OWNER_REL) << endowment_node



	# Look up the Investment fund's node
	investment_fund_node = Neography::Node.find(INVESTMENT_NAME_INDEX, "name", data["investment_fund_name"]) # We need a primary key for investment funds

	# Relate the endowment to the investment fund
	investment_rel = endowment_node.outgoing(ENDOWMENT_INVESTMENT_REL) << investment_fund_node
	investment_rel.percent = 100;



	# Now we need to add a relationship for each charity

	# ... to be continued -MPB


end

