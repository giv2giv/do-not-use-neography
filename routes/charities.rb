class MyApp < Sinatra::Application
  # Run lynx localhost:4567/charities/611413914
  # 611413914 is an EIN of a charity. Charities are indexed by EIN - see config/g2g-config.rb for index constants
  get "/charities/find_by_ein/:ein" do
    content_type :json  
    ein = params[:ein]
    
    # look up the node by ein
    Charity.find_by_ein(ein).to_json
  end

  get "/charities/find_by_id/:id" do
    content_type :json  
    id = params[:id]
    
    # look up the node by id
    Charity.find_by_id(id).to_json
  end

  get "/charities/find_by_name/:name" do
    content_type :json
    name = params[:name]
    
    # look up the node by name
    Charity.find_by_name(name).to_json
  end

  get "/charities/delete/:id" do
    content_type :json  
    id = params[:id]
    
    # Delete by id
    Charity.delete(id).to_json  
  end

end
