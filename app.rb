# encoding: utf-8
require 'sinatra'
require 'rubygems'
require 'json'
require 'neography'
require 'bcrypt'
require 'awesome_print'

load 'config/g2g-config.rb'

class MyApp < Sinatra::Application
  enable :sessions

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
  end

  configure :development do
    # ...
  end

end

require_relative 'models/init'
require_relative 'routes/init'
