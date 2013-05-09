require 'rake'
require 'neography/tasks'
require 'neography'
require 'rubygems'
require 'spreadsheet' # excel library - http://spreadsheet.ch
require 'geokit'
require 'open-uri'
require 'net/http'
require 'nokogiri'

	
#include GeoKit::Geocoders
task :default => [:test]

task :test do
  ruby "test/charity_import_test.rb"
end

namespace :server do
    desc "start server"
    task :start do
        system "shotgun -p9393"
    end
end



namespace :neo do
	desc "sets up database, starts it, and seeds it with some test data -- use 'rake neo:setup[value] where value is the number of charities to import"
	task :setup, :arg1 do |t, args|
		exec "bundle install"
		exec "rake neo4j:install"
		exec "rake neo4j:start"
		charity_import(args[:arg1].to_i)
		initial_seed
	end # task


	desc "seed initial database - command takes form of 'rake neo:seed[value] where value is the number of charities to import"
	task :seed, :arg1 do |t, args|
		puts "Performing charity import: importing first #{args[:arg1]} charities -- PLEASE WAIT. TIME INTENSIVE PROCESS"
		charity_import(args[:arg1].to_i) #will halt the import at :arg1 number of charities
		puts "Setting up some initial indices and db entries ..."
		initial_seed # sets up initial indices and a few basic DB entries

	end


end # namespace

def charity_import(val)
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
	
				#unless File.exist?(EXCEL_DIRECTORY+'/'+File.basename(url))
	
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
				#end

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
	  					#if row != nil && @ii > 0 # skip row 0  - it contains headers - this is horribly inefficient but I do not yet know Ruby 	well. -MPB
	
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
	
							# geocode() below will begin to throw INFOs and ERRORs after reaching the geocoding service daily limit of API 	accesses. The default geocoding service is Google.
	
							#if address[0..5] == "PO BOX"
								#geodata = MultiGeocoder.geocode(city + ", " + state + " " + zip)
							#else
								#geodata = MultiGeocoder.geocode(address + " " + city + ", " + state + " " + zip)
							#end
		
							# Finally, create the neo4j node
	#						puts "Anything!" --- i used this as debugger code -- josh
							if @ii > 0
								#puts ein
								puts @ii
								charity = Charity.find_by_ein(ein)
	
								if charity==nil
									Charity.create(ein, name, address, city, state, zip, ntee_common, ntee_core)
								else
	
									# The charity node already exists
									# Update the existing node properties with data from the IRS import
									Charity.node.name = name
									Charity.node.address = address 
									Charity.node.city = city 
									Charity.node.state = state 
									Charity.node.zip = zip 
									Charity.node.ntee_common = ntee_common 
									Charity.node.ntee_core = ntee_core 
									#charity.node.latitude = latitude 
									#charity.node.longitude = longitude 
	
								end # END   charity.neo4j==nil
	
							end # END  if @ii > 0 
		
							# Count the charities
	  						@ii = @ii+1
		
							# Debugging mode - comment to load all charities
							exit if @ii > val
	
	  					#end #END if empty row or not 0th row   if row != nil && @ii > 0
					end
	
					# This doesn't work. I still don't like Ruby.
	
					end # END open charity file  open(EXCEL_DIRECTORY+'/'+File.basename(url), "wb") do |file|
	                end # END HTTP connection  Net::HTTP.start("www.irs.gov") do |http|
	        #ensure
	
	        end # END begin
	end # END looping through URLs   @urls.each do |url|
	
	puts "Imported #{@ii} charities."
	
	end #method definition

namespace :boo do
task :testingdis, :arg1 do |t, args|
		charity_import(args[:arg1].to_i) #will halt the import at :arg1 number of charities
end #task



end #namespace



def initial_seed()

	# Populate neo4j with first-run data
	# Only do this once unless you wipe your database between runs

	require 'neography'

	load 'config/g2g-config.rb'
	load 'lib/functions.rb'

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
	@neo4j.create_node_index(SHARE_INDEX)


	# Create sponsor organization, add to index for easy retrieval later
	sponsoring_organization = Neography::Node.create( "id" => generate_unique_id(), "name"=>SPONSOR_ORGANIZATION_NAME, "domain"=>SPONSOR_ORGANIZATION_DOMAIN)
	sponsoring_organization.add_to_index(ID_INDEX, ID_INDEX, sponsoring_organization.id)
	sponsoring_organization.add_to_index(TYPE_INDEX, TYPE_INDEX, SPONSOR_ORGANIZATION_TYPE)


	# Create first investment fund, add to index for easy retrieval later
	investment_fund = Neography::Node.create( "id" => generate_unique_id(), "name"=>INVESTMENT_FUND_NAME)
	investment_fund.add_to_index(ID_INDEX, ID_INDEX, investment_fund.id)
	investment_fund.add_to_index(TYPE_INDEX, TYPE_INDEX, INVESTMENT_FUND_TYPE)
	
	# Create Processor node
	processor = Neography::Node.create( "id" => generate_unique_id(), "name"=>PROCESSOR_NAME, "fee_threshold"=>"10.00", "fee"=>"0.25")
	processor.add_to_index(ID_INDEX, ID_INDEX, processor.id)
	processor.add_to_index(TYPE_INDEX, TYPE_INDEX, PROCESSOR_TYPE)
end #inital_seed


