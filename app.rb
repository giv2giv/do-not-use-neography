# app.rb
require 'rubygems'
require 'sinatra'
require 'json'
require 'neography'
require 'bcrypt'

require 'awesome_print'

load 'config/g2g-config.rb'
load 'lib/crud.rb'


# class App < Sinatra::Base
  set :static, true
  set :sessions, true
  set :public_folder, File.dirname(__FILE__) + '/static'


# The giv2giv API speaks JSON and JSON only., e.g. {"name":"Michael","email":"president.whitehouse.gov","password":"somethingfunny"}
@data = JSON.parse(request.body.read)

# Example getting charity by EIN 'rackup' go to lynx localhost:9292/charities/611413914
# Run  sudo service neo4j-service start && rackup &
# Run lynx localhost:9292/charities/611413914
# 611413914 is an EIN of a charity. Charities are indexed by EIN as detailed below
  get "/charities/:ein" do
        @ein = params[:ein]

        node = Neography::Node.find(CHARITY_EIN_INDEX, "ein", @ein)

	@email = session[:email]
        @name = node.name
        erb :charities

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

  post "/donorsignup/" do

	# Post JSON to this endpoint
	# {"email":"president.whitehouse.gov","password":"somethingfunny"}

        # Use bcrypt to store PW hashes
        @data["password"] = BCrypt::Password.create(@data["password"])

        # create_donor resides in lib/crud.rb
        donor_node = create_donor (@data)

        session[:email] = donor_node.email

        # Return ephemeral id for look-up during development, also name, email -- watch ID iterate
        content_type :json
        { :id => donor_node.neo_id, :email => donor_node.email, :password => donor_node.password }.to_json

  end

  post '/signin' do
	email = params[:email]
	password = params[:password]

	donor = Neography::Node.find(DONOR_EMAIL_INDEX, "email", email)

	unless donor.password == BCrypt::Password.new(params[:password])
		session[:email] = params[:email]
		redirect "/donor"

	end

	redirect "/loginfailed"
  end

# end

