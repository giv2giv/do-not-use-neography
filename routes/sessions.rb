class App < Sinatra::Application

#We want to do something like:
#https://gist.github.com/amscotti/1384524

  post '/login' do
    content_type :json
    data=JSON.parse(request.body.read)

    puts 'hi' + data[:email];

    session[:email] = data["email"]
    session[:password] = data["password"]
    email = data["email"]
    password = data["password"]
    
    donor_node = Donor.find_by_email(email)
      { :error => "Donor email not found" }.to_json
    
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

