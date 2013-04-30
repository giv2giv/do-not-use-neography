# encoding: utf-8
require 'sinatra'
require 'rubygems'
require 'json'
require 'neography'
require 'bcrypt'
require 'awesome_print'

load 'config/g2g-config.rb'
load 'lib/functions.rb'

class App < Sinatra::Application

use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => SPONSOR_ORGANIZATION_WEBSITE,
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => generate_unique_id()

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
