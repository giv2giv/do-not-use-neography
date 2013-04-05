# app.rb
require 'rubygems'
require 'sinatra'
require 'json'
require 'neography'
require 'bcrypt'
require "dm-core"
#for using auto_migrate!
require "dm-migrations"
require "digest/sha1"
require 'rack-flash'
require "sinatra-authentication"

use Rack::Session::Cookie, :secret => 'No idea what im doing. this is supposedly for authentication secret key stuff. dunno if it works!'
#if you want flash messages
use Rack::Flash


require 'awesome_print'

load 'config/g2g-config.rb'
load 'lib/crud.rb'


# class App < Sinatra::Base
  set :static, true
  set :sessions, true
  set :public_folder, File.dirname(__FILE__) + '/static'


  post "/createdonor/" do

	#send raw JSON to this endpoint, e.g. {"name":"Michael","email":"president.whitehouse.gov","password":"somethingfunny"}
	@data = JSON.parse(request.body.read)

	# Use bcrypt 
	@data["password"] = BCrypt::Password.create(@data["password"])

	# create_donor resides in lib/crud.rb
	donor_node = create_donor (@data)

	session[:email] = donor_node.email

	# Return ephemeral id for look-up during development, also name, email -- watch ID iterate
	content_type :json
  	{ :id => donor_node.neo_id, :name => donor_node.name, :email => donor_node.email, :password => donor_node.password }.to_json

  end

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

  post '/signup' do
	user = User.create(params[:user])
	user.password_salt = BCrypt::Engine.generate_salt
	user.password_hash = BCrypt::Engine.hash_secret(params[:user][:password], user.password_salt)
	if user.save
		session[:user] = user.token
		redirect "/" 
	else
		redirect "/signup?email=#{params[:user][:email]}"
  end
  end

# end

