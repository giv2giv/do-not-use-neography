# app.rb
require 'rubygems'
require 'sinatra'
require 'json'
require 'neography'
require 'bcrypt'


require 'awesome_print'

load 'config/g2g-config.rb'
load 'lib/crud.rb'
load 'models/donor.rb'

# class App < Sinatra::Base
  set :static, true
  set :sessions, true
  set :public_folder, File.dirname(__FILE__) + '/static'



# Example getting charity by EIN 'rackup' go to lynx localhost:9292/charities/611413914
# Run  sudo service neo4j-service start && rackup &
# Run lynx localhost:9292/charities/611413914
# 611413914 is an EIN of a charity. Charities are indexed by EIN as detailed below
  get "/charities/findein/:ein" do
		# The giv2giv API speaks JSON and JSON only., e.g. {"name":"Michael","email":"president.whitehouse.gov","password":"somethingfunny"}
		#@data = JSON.parse(request.body.read)
		content_type :json

		# How do we provide this endpoint to logged in users only?
		@email = session[:email]

		@ein = params[:ein]

		# look up the node by ein
		charity_node = Neography::Node.find(CHARITY_EIN_INDEX, CHARITY_EIN_INDEX, @ein)


		# if not found
		if charity_node.nil?
        	{ :error => "No match for #{@ein}" }.to_json

		# if a bunch of nodes are found neography returns an array
		elsif charity_node.kind_of?(Array)

		response = Array.new 
		charity_node.each do |charity|
			response <<  { :neo_id => charity.neo_id, :name => charity.name }
		end
		response.to_json

		else # if one node is found
			{ :neo_id =>charity_node.neo_id, :ein => charity_node.ein, :name => charity_node.name }.to_json
		end

  end


  get "/charities/findname/:name" do
	@name = params[:name]
        node = Neography::Node.find(CHARITY_NAME_INDEX, CHARITY_NAME_INDEX, @ein)

  end

# Note, sinatra's routes must be in order. The framework goes down the list one by one to check routes. 
  get "/" do
    erb :home_index
  end

  get "/index" do
    erb :index
  end

  post '/putdat' do  
    erb :putdat
  end

	get "/donorsignup" do

#		erb :donorsignup
	end


  post "/donorsignup" do
		# can  almost use a curl command for sending json to this route, using a command line command in this format below
		#curl --data '{"first_name":"Data","city":"Data","password":"Data","address1":"Data",
		#"address2":"Data","city":"Data","state":"Data","country":"Data","zip":"Data","node_id":"Data",
		#"created_at":"Data","facebook_token":"Data","dwolla_token":"Data","twitter_token":"Data"}' http://localhost:9393/donorsignupD

		content_type :json
		data=JSON.parse(request.body.read)

	# Post JSON to this endpoint
	# {"email":"president.whitehouse.gov","password":"somethingfunny"}
		name=data["first_name"]
		city=data["city"]
		email=data["email"]
		address1=data["address1"]
		address2=data["address2"]
		state=data["state"]
		country=data["country"]
		zip=data["zip"]
		node_id=data["node_id"]
		created_at=data["created_at"]
		facebook_token=data["facebook_token"]
		dwolla_token=data["dwolla_token"]
		twitter_token=data["twitter_token"]
		password = BCrypt::Password.create(data["password"])
		# Use bcrypt to store PW hashes
		new_user=Donor.new(name, email, password, address1, address2, city, state, country, zip, node_id, created_at, facebook_token, dwolla_token, twitter_token )
		# create_donor resides in lib/crud.rb
		#donor_node = create_donor (@data)

		#session[:email] = donor_node.email

        # Return ephemeral id for look-up during development, also name, email -- watch ID iterate
#        content_type :json
#	{ :id => donor_node.neo_id, :email => donor_node.email, :password => donor_node.password }.to_json
  end

  post '/donorsignin' do

	email = params[:email]
	password = params[:password]

	donor_node = Neography::Node.find(DONOR_EMAIL_INDEX, DONOR_EMAIL_INDEX, email)

	content_type :json

	if donor_node.nil?
        	response = { :error => "Donor email not found" }.to_json

	elsif donor_node.password == BCrypt::Password.new(params[:password])
		session[:email] = params[:email]
        	response = { :neo_id =>donor_node.neo_id, :email => donor_node.email, :password => donor_node.password }.to_json
	else
        	response = { :error => "Invalid password" }.to_json
	end

  end



# end

