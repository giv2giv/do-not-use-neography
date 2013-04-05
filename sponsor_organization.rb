load 'config/g2g-config.rb'

# Populate neo4j with the sponsoring organization name - should only be done once
def sponsor_organization_initial_population()

        sponsoring_organization = Neography::Node.create("name"=>SPONSOR_ORGANIZATION_NAME)
        sponsoring_organization.add_to_index(TYPE_INDEX, TYPE_INDEX, SPONSOR_ORGANIZATION_TYPE)

end


# find the neo4j node for the sponsoring organization
# returns the neo4j node
def fetch_sponsor_organization_node()

	return Neography::Node.find(SPONSOR_INDEX,SPONSOR_INDEX,SPONSOR_ORGANIZATION_NAME)

end
