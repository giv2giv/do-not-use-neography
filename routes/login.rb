class MyApp < Sinatra::Application
  post "/donorsignup" do
    # can use a curl command for sending json to this route, using a command line command in the format below
    # curl --data '{"first_name":"Data","city":"Data","password":"Data","address1":"Data",
    # "address2":"Data","city":"Data","state":"Data","country":"Data","zip":"Data","node_id":"Data",
    # "created_at":"Data","facebook_token":"Data","dwolla_token":"Data","twitter_token":"Data"}' 
    # http://localhost:9393/donorsignup
    
    # Post JSON to this endpoint
    # {"email":"president.whitehouse.gov","password":"somethingfunny"}
    
    content_type :json
    data=JSON.parse(request.body.read)
    puts "parsing JSON data"
    puts data
    puts ""
    
    # search to see if the email has been used for another account
    @donor = Donor.find(data["email"])
    
    # if there was nothing found by the email check, proceed to create new donor. otherwise, display the results of the email search
    if @donor == nil
      puts "Created user >>>> "
      @donor=Donor.create(data["first_name"], data["email"], data["password"], data["address1"], data["address2"], data["city"], data["state"], data["country"], data["zip"], data["created_at"], data["facebook_token"], data["dwolla_token"], data["twitter_token"] )
      return @donor
    else
      puts "USER EXISTS >>>> "
      puts @donor
      return @donor
    end
    
    #session[:email] = donor_node.email
    
    # Return ephemeral id for look-up during development, also name, email -- watch ID iterate
    #        content_type :json
    #	{ :id => donor_node.neo_id, :email => donor_node.email, :password => donor_node.password }.to_json
  end

  post '/donorsignin' do
    content_type :json
    data=JSON.parse(request.body.read)
    email = data["email"]
    password = data["password"]
    
    donor_node = Donor.find_by_email(email)
    
    if donor_node.nil?
      response = { :error => "Donor email not found" }.to_json
      
    elsif donor_node.password == BCrypt::Password.new(data["password"])
      session[:email] = data["email"]
      session[:id] = data["id"]
      response = { :id =>donor_node.id, :email => donor_node.email, :password => donor_node.password }.to_json
    else
      response = { :error => "Invalid password" }.to_json
    end #if
    
  end #donorsignin

end

