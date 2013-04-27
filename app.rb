# encoding: utf-8
require "bundler/setup"
require 'sinatra'
#require 'haml'
require 'rubygems'
require 'sinatra'
require 'json'
require 'neography'
require 'bcrypt'
require 'awesome_print'

load 'config/g2g-config.rb'

class MyApp < Sinatra::Application
  enable :sessions
  set :static, true
  set :public_folder, File.dirname(__FILE__) + '/static'

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
