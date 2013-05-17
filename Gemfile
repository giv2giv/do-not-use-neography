# All dependencies should go here.
# then require your gems as usual
# You can use one bundle-install to include all gems.
# Good docs here:  http://blog.engineyard.com/2009/using-the-rubygems-bundler-for-your-app
source "https://rubygems.org"

# The basics ...
gem "sinatra"      # bare bones web framework
gem "rake"         # Rake is MAKE for ruby, and is useful for managing our library of scripts.
gem "test-unit"    # Unit test our libraries.
gem "json"         # For managing json


# The specifics ...
# gem "neography", :git => "git://github.com/maxdemarzi/neography.git" # Neo4J library
gem "dwolla-ruby", :git => "git://github.com/Dwolla/dwolla-ruby.git" # Dwolla handles financial transactions

# bcrypt and sinatra-authentication doesn't work with jruby. 
# gem "bcrypt-ruby"  # encryption.  dUH.
# gem "sinatra-authentication" #authentication

# Required for charity import
gem "spreadsheet" # Excel library for reading IRS files - http://spreadsheet.ch
gem "geokit"      # Distance calculator
gem "nokogiri"    # Easy HTML parser

# Required for neography - see https://github.com/maxdemarzi/neography/wiki/Dependencies
gem "os"          # useful and easy functions, like OS.windows? (=> true or false) OS.bits ( => 32 or 64) etc"
gem "httparty"    # simple clean api for making http requests.

# Developer tool
gem "awesome_print"

