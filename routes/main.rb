# encoding: utf-8
class App < Sinatra::Application
  get "/" do
    @title = "Welcome to Giv2Giv API"        
    haml :main
  end
  get "/test" do
    erb :test
  end
end
