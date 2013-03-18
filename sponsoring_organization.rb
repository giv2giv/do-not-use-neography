SPONSORING_ORGANIZATION_NAME = "giv2giv"

# Populate neo4j with the sponsoring organization name - should only be done once
def sponsoring_organization_initial_population()

        sponsoring_organization = Neography::Node.create("name"=>SPONSORING_ORGANIZATION_NAME)
        sponsoring_organization.add_to_index("sponsoring_organization","name",SPONSORING_ORGANIZATION_NAME)

end


# find the neo4j node for the sponsoring organization
# returns the neo4j node
def fetch_sponsoring_organization_node()

	return Neography::Node.find("sponsoring_orgniazation","name",SPONSORING_ORGANIZATION_NAME)

end
