class App < Sinatra::Application

## Curl commands to server take this general format, replacing the url suffix and ROUTE as needed
## curl -i -H "Accept: application/json" -X DELETE http://localhost:9393/donor/1 -d ''



  get '/donors' do
	#get list of ALL donors -- method needed in models/donor.rb
	donors = Neography::Node.find(TYPE_INDEX, TYPE_INDEX, DONOR_TYPE)
	puts donors
	puts donors.class
	if ! donors
		puts "No results found"
	else
		puts donors.length
		if donors.class == "Neography::Node"# This is needed because if there is only one result, the class is "Neography::Node" - 2 or more and it is "Array"
			puts donors
			puts "SOMETHING!"
		
		else
			donors.each do |donor|
				puts donors.length
				puts donor
				puts "SOMETHINGE ELSE!"
			end
		end
	end
#	end
	puts
#	donors=Donor.find_all
#	puts donors
  end

  get '/donors/:id' do
	@donor=Donor.find_by_id(params[:id])
	puts @donor
	puts @donor.name
	puts @donor.email
	puts @donor.neo_id	
	puts @donor.id
  end #/donor/:email

  delete '/donors/:id' do
## change this route to /donor/:id at some point
	@donor=Donor.find_by_id(params[:id])
	puts @donor
	begin
		@donor.del
	rescue NoMethodError => error
		puts "Received a NoMethodError while executing request: #{error} ---- this is likely because the database record wasn't found."
	end
		
	puts @donor
  end
  
  post '/donors' do
	##this will at some point be :id, i'm just using :email cuz it makes it easier for me to test -- josh
##  data takes form of: ( name, email, password, address1, address2, city, state, country, zip, facebook_token, dwolla_token, twitter_token )

=begin
curl -i -H "Accept: application/json" -X POST -d '{"name":"josh","email":"newemail","password":"password","address1":"home","address2":"virginia","city":"hburg","state":"va","country":"usa","zip":"22801","facebook_token":"token","dwolla_token":"token","twitter_token":"token", "node_type":"donor"}' http://localhost:9393/donors

=end

	content_type :json
	data=JSON.parse(request.body.read)
	search=Donor.find_by_email(data["email"])
	#not the best way to impement a search to see if the email is in use already, but hey it works. can improve later
	if ! search
		@donor=Donor.create(data["name"], data["email"], data["password"], data["address1"], data["address2"], data["city"], data["state"], data["country"], data["zip"], data["facebook_token"], data["dwolla_token"], data["twitter_token"])
		puts "Created a new user, with the following data:"
		puts data
		puts @donor
		puts @donor.id
		puts @donor.name
	else
		puts "EMAIL ALREADY IN USE"
	end #if ! search
  end

  ### the following is consistent with the other donor/:email routes. Should make it easier to add values because of that
  ### TO DELETE A PROPERTY, SEND THE VALUE OF THAT PROPERTY AS "nil"
  post '/donors/:id' do #:property/:value' do
    content_type :json
    data=JSON.parse(request.body.read)
    @object = Donor.find_by_id(params[:id])
    puts @object
	data.each do |property, value|
#		prop=data["property"]
		@object[property]=value
		puts @object
    end #do
  end #put /donor/:email/:prop/:val
    





## change this route to /donor/:id at some point
  get '/donor/:email/endowment' do
	#get list of all endowments donor contributes to
  end #get /donor/email/endowment

## change this route to /donor/:id at some point
  delete '/donor/:email/endowment' do
	#delete donor's connection to some endowment

	data=JSON.parse(request.body.read)

        content_type :json
        Donor.remove_endowment(session[:id], data['endowment_id'], data['amount']).to_json
  end #delete /donor/email/endowment

## change this route to /donor/:id at some point

  put '/donor/:email/endowment' do
	#create connection to endowment - donor will contribute 'amount'
	data=JSON.parse(request.body.read)

	content_type :json
	Donor.add_endowment(session[:id], data['endowment_id'], funding_source_scheduled_transfer_id).to_json

  end # put /donor/email/endowment

## change this route to /donor/:id at some point
  post '/donor/:email/endowment' do
	#alter contributions to endowment
  end #post /donor/email/endowment
  


end

