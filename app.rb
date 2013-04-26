# app.rb
require 'rubygems'
require 'sinatra'
require 'json'
require 'neography'
require 'bcrypt'


require 'awesome_print'

load 'config/g2g-config.rb'
load 'models/donor.rb'
load 'models/charity.rb'
load 'models/endowment.rb'


use Rack::MethodOverride

# class App < Sinatra::Base
  set :static, true
  set :sessions, true
  set :public_folder, File.dirname(__FILE__) + '/static'



# Example getting charity by EIN 'rackup' go to lynx localhost:9292/charities/611413914
# Run  sudo service neo4j-service start && rackup &
# Run lynx localhost:4567/charities/611413914
# 611413914 is an EIN of a charity. Charities are indexed by EIN - see config/g2g-config.rb for index constants
  get "/charities/find_by_ein/:ein" do
	content_type :json

	ein = params[:ein]

	# look up the node by ein
	Charity.find_by_ein(ein).to_json
  end

  get "/charities/find_by_id/:id" do
        content_type :json

        id = params[:id]

        # look up the node by id
        Charity.find_by_id(id).to_json
  end

  get "/charities/find_by_name/:name" do
	content_type :json

	name = params[:name]

	# look up the node by name
	Charity.find_by_name(name).to_json
  end

  get "/charities/delete/:id" do
	content_type :json

	id = params[:id]

	# Delete by id
	Charity.delete(id).to_json

  end

# Note, sinatra's routes must be in order. The framework goes down the list one by one to check routes. 
  get "/" do
    erb :home_index
  end

  get "/index" do
    erb :index
  end

	get "/donorsignup" do

#		erb :donorsignup
	end

  post "/donorsignup" do
		# can use a curl command for sending json to this route, using a command line command in the format below
		#curl --data '{"first_name":"Data","city":"Data","password":"Data","address1":"Data",
		#"address2":"Data","city":"Data","state":"Data","country":"Data","zip":"Data","node_id":"Data",
		#"created_at":"Data","facebook_token":"Data","dwolla_token":"Data","twitter_token":"Data"}' http://localhost:9393/donorsignup
	

	# Post JSON to this endpoint
	# {"email":"president.whitehouse.gov","password":"somethingfunny"}

		content_type :json
		data=JSON.parse(request.body.read)
		puts "parsing JSON data"
		puts data
		puts ""

		# search to see if the email has been used for another account
		@donor = Donor.find(data["email"])
		
		# if there was nothing found by the email check, proceed to create new donor. otherwise, display the results of the email search
		if @donor == nil
			puts "Created user >>>> "
			@donor=Donor.create(data["first_name"], data["email"], data["password"], data["address1"], data["address2"], data["city"], data["state"], data["country"], data["zip"], data["node_id"], data["created_at"], data["facebook_token"], data["dwolla_token"], data["twitter_token"] )
			return @donor
		else
			puts "USER EXISTS >>>> "
			puts @donor
			return @donor
		end


		#session[:email] = donor_node.email

        # Return ephemeral id for look-up during development, also name, email -- watch ID iterate
#        content_type :json
#	{ :id => donor_node.neo_id, :email => donor_node.email, :password => donor_node.password }.to_json
  end

  post '/donorsignin' do
		content_type :json
		data=JSON.parse(request.body.read)
		email = data["email"]
		password = data["password"]

		donor_node = Neography::Node.find(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)

		if donor_node.nil?
			response = { :error => "Donor email not found" }.to_json

		elsif donor_node.password == BCrypt::Password.new(data["password"])
			session[:email] = data["email"]
			session[:id] = data["id"]
        	response = { :neo_id =>donor_node.neo_id, :email => donor_node.email, :password => donor_node.password }.to_json
		else
        	response = { :error => "Invalid password" }.to_json
	end #if

  end #donorsignin

	delete '/donor/:email' do
		##TODO: needs check to see if you really want to delete the donor. perhaps put that in a get request that then redirects here?
		Donor.delete(params[:email])
	end #delete

	post "/donor/find_by_id" do
### AS THIS CURRENTLY STANDS IT WILL FIND AN OBJECT WITH THE VALID EMAIL AND RETURN IT'S NEO4J ID. WE SHOULD BE MOVING TOWARD THIS
### TYPE OF ID'ing NODES, IE, WHERE WE RELY ON THE NODE ID INSTEAD OF ANY OTHER ID
#        	id = params[:ein]
        	content_type :json
			data=JSON.parse(request.body.read)
        	# look up the node by id

#        	Donor.find_by_id(id).to_json
			donor=Donor.find_by_email(data["email"])
			puts donor.neo_id
  	end

	get '/donor/:id' do
                #TODO this should probably be the confirmation page for deleting a user, then it redirects to HTTP delete route
                yield
        end #/donor/:email

	get '/donor/:email' do
		#TODO this should probably be the confirmation page for deleting a user, then it redirects to HTTP delete route
		yield
	end #/donor/:email

	get '/profile/:email' do
#		TODO This is should return all the data that is part of a user's profile.
#		including: endowment packages, contact info, any other public info
		yield
	end #/profile/:email


### The following route is semi nonfunctional, mostly because the add_property method in Donor.rb isn't correct -josh
	post '/donor/addproperty' do
		content_type :json
		data=JSON.parse(request.body.read)
		@object = Donor.find(data["email"])
		puts @object
		
		data.each do |key, value|
			if key!="email"
				@object.add_attribute(key, value)
			end
		end #do

	end # post /donor/addproperty



# Begin endowments

	# Create a new endowment
	post '/endowment/create' do
		content_type :json
		data=JSON.parse(request.body.read)
		Endowment.create(session[:id], data['name'], data['amount'], data['frequency']).to_json
	end

	# endowment modified, add new investment fund
	get '/endowment/:endowment_id/add_investment_fund/:fund_id' do
		content_type :json
		Endowment.add_investment_fund(params[:endowment_id]).to_json

	end

	# endowment modified, add new charity to grantees
	get '/endowment/:endowment_id/add_charity/:charity_id' do
		content_type :json
		Endowment.add_charity(params[:endowment_id], params[:charity_id]).to_json
	end

	# session donor signs up to contribute to an endowment
	get '/endowment/:endowment_id/add_donor' do
		content_type :json
		Endowment.add_donor(params[:endowment_id]).to_json
	end


