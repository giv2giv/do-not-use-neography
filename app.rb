# app.rb
require 'rubygems'
require 'sinatra'
require 'json'
require 'neography'

load 'config/g2g-config.rb'


# class App < Sinatra::Base
  set :static, true
  set :public_folder, File.dirname(__FILE__) + '/static'


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

