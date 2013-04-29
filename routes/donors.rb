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
  

  
  put '/donor/:email' do
	##this will at some point be :id, i'm just using :email cuz it makes it easier for me to test -- josh
##  data takes form of: ( name, email, password, address1, address2, city, state, country, zip, facebook_token, dwolla_token, twitter_token )
###  curl -i -H "Accept: application/json" -X PUT -d '{"name":"josh","email":"joshemail","password":"password",
##"address1":"home","address2":"virginia","city":"hburg","state":"va","country":"usa",
##"zip":"22801","facebook_token":"token","dwolla_token":"token","twitter_token":"token"}' http://localhost:9393/donor/joshemail
	content_type :json
	data=JSON.parse(request.body.read)
	puts data
	search=Donor.find_by_email(data["email"])
	#not the best way to impement a search to see if the email is in use already, but hey it works. can improve later
	if ! search
		@donor=Donor.create(data["name"], data["email"], data["password"], data["address1"], data["address2"], data["city"], data["state"], data["country"], data["zip"], data["facebook_token"], data["dwolla_token"], data["twitter_token"])
	else
		puts "EMAIL ALREADY IN USE"
	end #if ! search
  end

  get '/donor/:email' do
	@donor=Donor.find_by_email(params[:email])
	puts @donor
	puts @donor.name
	puts @donor.email
	puts @donor.neo_id	
  end #/donor/:email

  delete '/donor/:email' do
	@donor=Donor.find_by_email(params[:email])
	puts @donor
	@donor.del
	puts @donor
  end



  

  ### the following is consistent with the other donor/:email routes. Should make it easier to add values because of that
  post '/donor/:email' do #:property/:value' do
    content_type :json
    data=JSON.parse(request.body.read)
    @object = Donor.find_by_email(params[:email])
    puts @object
	data.each do |property, value|
#		prop=data["property"]
		if property != "email"
			@object[property]=value
		end
		puts @object
    end #do
  end #put /donor/:email/:prop/:val
    

  

end

