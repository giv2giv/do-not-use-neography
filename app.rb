# app.rb
require 'rubygems'
require 'sinatra'
require 'json'
require 'neography'

require 'awesome_print'

load 'config/g2g-config.rb'
load 'lib/crud.rb'


# class App < Sinatra::Base
  set :static, true
  set :public_folder, File.dirname(__FILE__) + '/static'

# Authentication 
  use Rack::Session::Pool, :expire_after => 2592000

# Pull all JSON into a scope variable
  before do
	@data = JSON.parse(request.body.read) rescue {}
  end



# Example getting charity by EIN 'rackup' go to lynx localhost:9292/charities/611413914
# Run  sudo service neo4j-service start && rackup &
# Run lynx localhost:9292/charities/611413914
# 611413914 is an EIN of a charity. Charities are indexed by EIN as detailed below
  get "/charities/:ein" do
	@ein = params[:ein]

	node = Neography::Node.find(CHARITY_EIN_INDEX, "ein", @ein)

	@name = node.name
	erb :charities

  end


  post "/createdonor/" do
  #get "/createdonor/" do  # Quicker to test using get

	# Test data
	@data ={
    		"name" => "Test",
    		"email" => "president@whitehouse.gov"
  	}.to_json

	@data = JSON.parse(@data)

	# create_donor in lib/crud.rb
	donor_node = create_donor (@data)

	# Return ephemeral id for look-up during development, name, email -- watch ID iterate
	content_type :json
  	{ :id => donor_node.neo_id, :name => @data["name"], :email => @data["email"] }.to_json

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

# end

