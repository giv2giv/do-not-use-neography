



=begin
Core g2g settings
=end

# The nonprofit running the fund
SPONSOR_ORGANIZATION_NAME = "giv2giv"

# The name of the index allowing for lookups of all nodes of type donor, charity, etc
TYPE_INDEX="type_index"

# The types of each node - used to look up all nodes of a single type

SPONSOR_ORGANIZATION_TYPE = "sponsor"
DONOR_TYPE = "donor"
ENDOWMENT_TYPE = "endowment"
CHARITY_TYPE = "charity"

# Duplicate nodes for when information from the IRS changes - Only keeping track to see how often this happens
OLD_CHARITY_TYPE = "old_charity"


# The name of the charity index
CHARITY_EIN_INDEX="charity_ein_index"
CHARITY_NAME_INDEX="charity_name_index"

# The name of the donor index
DONOR_INDEX="donor_index"

# The name of the package index
PACKAGE_INDEX="package_index"

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

