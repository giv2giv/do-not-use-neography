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
# entering this curl command almost works right for sending json to this route .... curl -i --data "first_name=josh","city=poop","password=stuff","address1=Null","address2=Null","city=Null","state=Null","country=Null","zip=Null","node_id=Null","created_at=Null","facebook_token=Null","dwolla_token=Null","twitter_token=Null" http://localhost:9393/donorsignup
	content_type :json

	# Post JSON to this endpoint
	# {"email":"president.whitehouse.gov","password":"somethingfunny"}
		name=params[:first_name]
		city=params[:city]
		password = BCrypt::Password.create(params[:password])
		# Use bcrypt to store PW hashes
		new_user=Donor.new(name, city, password,"Null","Null","Null","Null","Null","Null","Null","Null","Null","Null","Null" )
		# create_donor resides in lib/crud.rb
		#donor_node = create_donor (@data)

		#session[:email] = donor_node.email

        # Return ephemeral id for look-up during development, also name, email -- watch ID iterate
#        content_type :json
#	{ :id => donor_node.neo_id, :email => donor_node.email, :password => donor_node.password }.to_json
    puts @donor_node
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

