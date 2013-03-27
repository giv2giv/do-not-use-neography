
=begin
Core g2g settings
=end

# The nonprofit running the fund
SPONSOR_ORGANIZATION_NAME = "giv2giv"

# The name of the charity index
CHARITY_INDEX="charity_index"
# The name of the donor index
DONOR_INDEX="donor_index"
# The name of the package index
PACKAGE_INDEX="package_index"
# The name of the sponsoring organization index
SPONSOR_INDEX="sponsor_index"

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

