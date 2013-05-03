
# Populate neo4j with first-run data
# Only do this once unless you wipe your database between runs

require 'neography'

load 'config/g2g-config.rb'

# Neography only supports creating indexes using "Phase 1"
@neo4j = Neography::Rest.new

# Create indices
@neo4j.create_node_index(TYPE_INDEX)
@neo4j.create_node_index(ID_INDEX)
@neo4j.create_node_index(CHARITY_NAME_INDEX)
@neo4j.create_node_index(CHARITY_EIN_INDEX)
@neo4j.create_node_index(DONOR_EMAIL_INDEX)
@neo4j.create_node_index(DONOR_TOKEN_INDEX)
@neo4j.create_node_index(ENDOWMENT_NAME_INDEX)

# I prefer "Phase 2"

# Create sponsor organization, add to index for easy retrieval later
sponsoring_organization = @neo4j.create_node("name"=>SPONSOR_ORGANIZATION_NAME, "domain"=>SPONSOR_ORGANIZATION_DOMAIN)
@neo4j.add_node_to_index(TYPE_INDEX, TYPE_INDEX, SPONSOR_ORGANIZATION_TYPE, sponsoring_organization)

#Create first investment fund, add to index for easy retrieval later
investment_fund = @neo4j.create_node("name"=>INVESTMENT_FUND_NAME)
@neo4j.add_node_to_index(TYPE_INDEX, TYPE_INDEX, INVESTMENT_FUND_TYPE, investment_fund);
