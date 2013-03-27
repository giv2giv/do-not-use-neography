# app.rb
require 'rubygems'
# require 'sinatra/base'
require 'sinatra'


# class App < Sinatra::Base
  set :static, true
  set :public_folder, File.dirname(__FILE__) + '/static'

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

