# encoding: utf-8
require 'sinatra'
require 'rubygems'
require 'json'
require 'neography'
require 'bcrypt'
require 'awesome_print'

load 'config/g2g-config.rb'

class App < Sinatra::Application
  enable :sessions

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
  end

  configure :development do
    # ...
    set :protection, :origin_whitelist => ['http://localhost']
  end
end

require_relative 'models/init'
require_relative 'routes/init'
