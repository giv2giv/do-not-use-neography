require 'rubygems'
require 'neography' #neo4j access library - https://github.com/maxdemarzi/neography/
require 'spreadsheet' # excel library - http://spreadsheet.ch
require 'geokit'

include GeoKit::Geocoders

load 'neo4j_config.rb'


@neo = Neography::Rest.new

#Open the excel file passed in from the commandline
book = Spreadsheet.open ARGV[0]

# Data is in the first "sheet"
worksheet = book.worksheet 0

#counter
@ii=0

=begin
Key/Values in the excel files:
[
    [ 0] "E. I. N.",
    [ 1] "Name",
    [ 2] "In Care of Name",
    [ 3] "Address",
    [ 4] "City",
    [ 5] "State",
    [ 6] "Zip Code",
    [N] => Foundation Code
    [ 7] "Group Exemption Number",
    [ 8] "Subsection Code",
    [ 9] "Affiliation Code",
    [10] "Classification Code",
    [11] "Ruling Date",
    [12] "Deductibility Code",
    [13] "Foundation Code",
    [14] "Activity Code",
    [15] "Organization Code",
    [16] "Exempt Organization Status Code",
    [17] "Advanced Ruling Expiration Date",
    [18] "Tax Period",
    [19] "Asset Code",
    [20] "Income Code",
    [21] "Filing Requirement Code",
    [22] "PF Filing Requirement Code",
    [23] "Blank",
    [24] "Accounting Period",
    [25] "Asset Amount",
    [26] "Income Amount",
    [27] "Negative Sign",
    [28] "Form 990 Revenue Amount",
    [29] "Negative Sign",
    [30] "NTEE Code",
    [31] "Sort or Secondary Name"
]
=end

# Iterate through the .xls rows
worksheet.each do |row|

  if row != nil && @ii > 0 # skip row 0  - it contains headers

	# Pull data from the row
  	ein = row[0].to_s()
  	name = row[1].to_s()
  	address = row[3].to_s()
  	city = row[4].to_s()
  	state = row[5].to_s()
  	zip = row[6].to_s()

	# Use geodata to grab the latitude and longitude
	geodata = MultiGeocoder.geocode(address + city + state + zip)

	# Finally, create the neo4j node
	@neo.create_node('type' => 'charity', 'name' => name, 'ein' => ein, 'address'=> address, 'city' => city, 'state' => state, 'zip' => zip, 'latitude' => geodata.lat, 'longitude' => geodata.lng)

	# Count the charities
  	@ii = @ii+1

	# Debugging mode
	exit if @ii > 5

  end
end

# This doesn't work. I still don't like Ruby.
puts "Imported #{@ii} charities."
