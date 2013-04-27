# encoding: utf-8
class MyApp < Sinatra::Application
  get "/" do
    @title = "Welcome to Giv2Giv API"        
    haml :main
  end
end
