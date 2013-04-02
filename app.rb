# app.rb
require 'rubygems'
require 'sinatra'
require 'json'
require 'neography'

require 'omniauth'
require 'omniauth-dwolla'
require 'omniauth-facebook'
require 'omniauth-openid'
require 'omniauth-twitter'

require 'awesome_print'

load 'config/g2g-config.rb'
load 'lib/crud.rb'


# class App < Sinatra::Base
  set :static, true
  set :public_folder, File.dirname(__FILE__) + '/static'

# Authentication 

  use Rack::Session::Cookie
  use OmniAuth::Builder do
	provider :dwolla, ENV['DWOLLA_KEY'], ENV['DWOLLA_SECRET'], :scope => 'accountinfofull|send|request'
	provider :facebook, "APP_ID", "APP_SECRET"
	provider :open_id, OpenID::Store::Filesystem.new('/tmp')
	provider :twitter, 'consumerkey', 'consumersecret'
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

  post '/auth/:name/callback' do
	auth = request.env['omniauth.auth']
	"Hello, #{auth['user_info']['name']}, you logged in via #{params['provider']}."
	# do whatever you want with the information!
  end

  post "/createdonor/" do

	#send raw JSON to this endpoint, e.g. {"name":"Michael","email":"president.whitehouse.gov"}
	@data = JSON.parse(request.body.read)

	# create_donor resides in lib/crud.rb
	donor_node = create_donor (@data)

	donor_node.happy = "fun" # This inserts a new property in the database node

	# Return ephemeral id for look-up during development, also name, email -- watch ID iterate
	content_type :json
  	{ :id => donor_node.neo_id, :name => donor_node.name, :email => donor_node.email, :happy => donor_node.happy }.to_json
  	#{ :name => "Michael", :email => "president.whitehouse.gov" }.to_json

  end


  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end
  
  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end
  
  get '/protected' do
    throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
    erb "<pre>#{request.env['omniauth.auth'].to_json}</pre><hr>
         <a href='/logout'>Logout</a>"
  end
  
  get '/logout' do
    session[:authenticated] = false
    redirect '/'
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

