require 'rubygems'
require 'neography' #neo4j access library - https://github.com/maxdemarzi/neography/
require 'spreadsheet' # excel library - http://spreadsheet.ch
require 'geokit'
require 'open-uri'
require 'net/http'
require 'nokogiri'

#include GeoKit::Geocoders

load 'config/g2g-config.rb'
load 'IRS_charity_classification_codes.rb'
load 'models/charity.rb'

# Make the directory to write the excel files if it doesn't exist
Dir.mkdir(EXCEL_DIRECTORY) unless File.exists?(EXCEL_DIRECTORY)

# Initialize a hash
@urls = []

# Hit the IRS site and grab list of regex matching files
# Nokogiri makes it easy, but probably a better way
doc = Nokogiri::HTML(open('http://www.irs.gov/pub/irs-soi/'))

# Grab all the links and store it in 
doc.xpath('//a/@href').each do |links|

	# There are a lot of unnecessary files in that directory so let's only include filenames matching eo_[^.]{2,4}.xls
	if links.content =~ /eo_[^.]{2,4}.xls/
		@urls << links.content
	end
end

# Download each one, write file to EXCEL_DIRECTORY/{filename}

@urls.each do |url|
#puts url
	begin
		Net::HTTP.start("www.irs.gov") do |http|
			resp = http.get("/pub/irs-soi/"+url)

			# Create the data store directory if it doesn't exist
			open(EXCEL_DIRECTORY+'/'+File.basename(url), "wb") do |file|

				# Write out the downloaded Excel file
   			file.write(resp.body)
				file.close
			
				# Open the file we just wrote with the spreadsheet gem functionality	
				book = Spreadsheet.open (EXCEL_DIRECTORY+'/'+File.basename(url))

				# Data is in the first "sheet"
					worksheet = book.worksheet 0

				#counter
				@ii=0

=begin
Key/Values in the excel files:

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
  					#if row != nil && @ii > 0 # skip row 0  - it contains headers - this is horribly inefficient but I do not yet know Ruby well. -MPB

						# Pull data from the row
  						ein = row[0].to_s().strip
#							puts ein --- i used this as debugger code -- josh
  						name = row[1].to_s().strip
  						address = row[3].to_s().strip
  						city = row[4].to_s().strip
  						state = row[5].to_s().strip
  						zip = row[6].to_s().strip
#							puts zip --- i used this as debugger code -- josh
						ntee_common = NTEE_COMMON_CODES[row[30].to_s().strip[0]]
						ntee_core = NTEE_CORE_CODES[row[30].to_s().strip]

						# Use geodata to grab the latitude and longitude

						# geocode() below will begin to throw INFOs and ERRORs after reaching the geocoding service daily limit of API accesses. The default geocoding service is Google.

						#if address[0..5] == "PO BOX"
							#geodata = MultiGeocoder.geocode(city + ", " + state + " " + zip)
						#else
							#geodata = MultiGeocoder.geocode(address + " " + city + ", " + state + " " + zip)
						#end
	
						# Finally, create the neo4j node
#						puts "Anything!" --- i used this as debugger code -- josh
						if @ii > 0
							#puts ein

							charity = Charity.new()

							charity.find_ein(ein)

							#puts existing_node
							# If the charity node already exists
							unless charity.neo4j==nil
								if !(
									# Check if the existing node properties are the same as the IRS import
									charity.neo4j.name == name &&
									charity.neo4j.address == address &&
									charity.neo4j.city == city &&
									charity.neo4j.state == state &&
									charity.neo4j.zip == zip &&
									charity.neo4j.ntee_common == ntee_common &&
									charity.neo4j.ntee_core == ntee_core 
									#charity.neo4j.latitude == latitude &&
									#charity.neo4j.longitude == longitude 
								)

									charity.create(name, ein, address, city, state, zip, ntee_common, ntee_core)


                                                                	# Create relationship of type 'old_charity' between new and old
									charity.neo4j.outgoing(:old_charity) << existing_node

									# Remove the existing node from the type index to avoid duplicates
									charity.neo4j.remove_from_index(TYPE_INDEX, TYPE_INDEX, CHARITY_TYPE)

									# Add the existing node to the type index as an old charity
                                                                	charity.neo4j.add_to_index(TYPE_INDEX, TYPE_INDEX, OLD_CHARITY_TYPE)

								end
							else # END   if existing_node==nil

								# If the charity node doesn't already exist then make a new node
								charity.create(name, ein, address, city, state, zip, ntee_common, ntee_core)

							end # END   else 
						end # END  if @ii > 0 
	
						# Count the charities
  						@ii = @ii+1
	
						# Debugging mode - comment to load all charities
						exit if @ii > 5000

  					#end #END if empty row or not 0th row   if row != nil && @ii > 0
				end

				# This doesn't work. I still don't like Ruby.

                        end # END open charity file  open(EXCEL_DIRECTORY+'/'+File.basename(url), "wb") do |file|
                end # END HTTP connection  Net::HTTP.start("www.irs.gov") do |http|
        #ensure

        end # END begin
end # END looping through URLs   @urls.each do |url|

puts "Imported #{@ii} charities."
