
SPONSORING_ORGANIZATION_NAME = "giv2giv"

def sponsoring_organization_initial_population()

        giv2giv = Neography::Node.create ("name" => SPONSORING_ORGANIZATION_NAME)
        giv2giv.add_to_index ("sponsoring_organization", "name", SPONSORING_ORGANIZATION_NAME)

end


# find the neo4j node for the sponsoring organization
# returns the neo4j node
def fetch_sponsoring_organization_node()

	return Neography::Node.find("sponsoring_orgniazation", "name", SPONSORING_ORGANIZATION_NAME)

end
