



=begin
Core g2g settings
=end

# The nonprofit running the fund
SPONSOR_ORGANIZATION_NAME = "giv2giv"

# The investment fund
INVESTMENT_FUND_NAME = "giv2giv investment fund"

# The name of the index allowing for lookups of all nodes of type donor, charity, etc
TYPE_INDEX="type_index"

# The name of the id index, throw every node in here with its ID
ID_INDEX = "id_index"

# The types of each node - indexed to look up all nodes of a single type

SPONSOR_ORGANIZATION_TYPE = "sponsor"
DONOR_TYPE = "donor"
ENDOWMENT_TYPE = "endowment"
CHARITY_TYPE = "charity"
INVESTMENT_FUND_TYPE = "investment_fund"


# Charity indices
CHARITY_NAME_INDEX="charity_name_index"
CHARITY_EIN_INDEX="charity_ein_index"


# Donor indices
DONOR_EMAIL_INDEX="donor_email_index"
DONOR_TOKEN_INDEX="donor_token_index" # look up donors by auth token


# Endowment indices
ENDOWMENT_NAME_INDEX="endowment_name_index"


ENDOWMENT_OWNER_REL=":owns"  # The owner donor->package relationship
ENDOWMENT_CONTRIBUTER_REL =":contributes"  # The contributing donor->package relationship
ENDOWMENT_INVESTMENT_REL =":invests"  # The contributing donor->package relationship
ENDOWMENT_SPONSOR_FEE_REL =":sponsor_fee"  # The contributing donor->package relationship
ENDOWMENT_INVESTMENT_FEE_REL =":investment_fee"  # The contributing donor->package relationship


# The name of the sponsoring organization index
SPONSOR_INDEX="sponsor_index"



# these are the default values:
Neography.configure do |config|
  config.protocol       = "http://"
  config.server         = "localhost"
  config.port           = 7474
  config.directory      = ""  # prefix this path with '/' 
  config.cypher_path    = "/cypher"
  config.gremlin_path   = "/ext/GremlinPlugin/graphdb/execute_script"
  config.log_file       = "neography.log"
  config.log_enabled    = false
  config.max_threads    = 20
  config.authentication = nil  # 'basic' or 'digest'
  config.username       = nil
  config.password       = nil
  config.parser         = MultiJsonParser
end



=begin
END core g2g settings
=end




=begin
Charity import settings
=end

# Define directory into which to write excel files
EXCEL_DIRECTORY = "charity_excel_files"

=begin
END charity import settings
=end



=begin
Dwolla-specific settings
=end

# Dwolla processes all transactions $10 and under for free
DWOLLA_FEE_THRESHOLD = 10.00

# Dwolla transaction fee for transaction amounts at or above TRANSACT_FEE_THRESHOLD
DWOLLA_TRANSACTION_FEE = 0.25

=begin
END Dwolla-specific settings
=end

