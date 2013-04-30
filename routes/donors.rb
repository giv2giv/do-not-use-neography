class App < Sinatra::Application

## Curl commands to server take this general format, replacing the url suffix and ROUTE as needed
## curl -i -H "Accept: application/json" -X DELETE http://localhost:9393/donor/1 -d ''



#  get "/donor/email/:email" do
    ### AS THIS CURRENTLY STANDS IT WILL FIND AN OBJECT WITH THE VALID EMAIL AND RETURN IT'S NEO4J ID. WE SHOULD BE MOVING TOWARD THIS
    ### TYPE OF ID'ing NODES, IE, WHERE WE RELY ON THE NODE ID INSTEAD OF ANY OTHER ID
    #        	id = params[:ein]
    # look up the node by id
    #        	Donor.find_by_id(id).to_json
#    donor=Donor.find_by_email(params[:email])
#    puts "Found donor:"
#    puts "\tid: "+donor.neo_id.to_s
#    print "\temail: "+donor.email
#  end
  
  get '/donor/:email' do
	@donor=Donor.find_by_email(params[:email])
	puts @donor
	puts @donor.name
	puts @donor.email
	puts @donor.neo_id	
  end #/donor/:email

  delete '/donor/:email' do
## change this route to /donor/:id at some point
	@donor=Donor.find_by_email(params[:email])
	puts @donor
	begin
		@donor.del
	rescue NoMethodError => error
		puts "Received a NoMethodError while executing request: #{error} ---- this is likely because the database record wasn't found."
	end
		
	puts @donor
  end
  
  put '/donor/:email' do
	##this will at some point be :id, i'm just using :email cuz it makes it easier for me to test -- josh
##  data takes form of: ( name, email, password, address1, address2, city, state, country, zip, facebook_token, dwolla_token, twitter_token )
###  curl -i -H "Accept: application/json" -X PUT -d '{"name":"josh","email":"joshemail","password":"password",
##"address1":"home","address2":"virginia","city":"hburg","state":"va","country":"usa",
##"zip":"22801","facebook_token":"token","dwolla_token":"token","twitter_token":"token"}' http://localhost:9393/donor/joshemail
	content_type :json
	data=JSON.parse(request.body.read)
	search=Donor.find_by_email(data["email"])
	#not the best way to impement a search to see if the email is in use already, but hey it works. can improve later
	if ! search
		@donor=Donor.create(data["name"], data["email"], data["password"], data["address1"], data["address2"], data["city"], data["state"], data["country"], data["zip"], data["facebook_token"], data["dwolla_token"], data["twitter_token"])
		puts "Created new users, with the following data:"
		puts data
		puts @donor
	else
		puts "EMAIL ALREADY IN USE"
	end #if ! search
  end

  ### the following is consistent with the other donor/:email routes. Should make it easier to add values because of that
  ### TO DELETE A PROPERTY, SEND THE VALUE OF THAT PROPERTY AS "nil"
  post '/donor/:email' do #:property/:value' do
    content_type :json
    data=JSON.parse(request.body.read)
    @object = Donor.find_by_email(params[:email])
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
	#delete donor's contributions to some endowment
  end #delete /donor/email/endowment

## change this route to /donor/:id at some point
  put '/donor/:email/endowment' do
	#create contributionn to endowment
  end # put /donor/email/endowment

## change this route to /donor/:id at some point
  post '/donor/:email/endowment' do
	#alter contributions to endowment
  end #post /donor/email/endowment
  


end

