class App < Sinatra::Application

#We want to do something like:
#https://gist.github.com/amscotti/1384524

post "/signup" do

	puts "Post to /donor/new or /charities/new"
end


post '/login' do
	content_type :json
	data=JSON.parse(request.body.read)

	donor_node = Donor.find_by_email(data["email"])
		{ :error => "Donor email not found" }.to_json
	  
	if donor_node.nil?
		response = { :error => "Donor email not found" }.to_json
	    
	elsif data["password"] == BCrypt::Password.new(donor_node.password)
		session[:email] = data["email"]
		session[:id] = data["id"]
		response = { :id =>donor_node.id, :email => donor_node.email, :password => donor_node.password }.to_json
	else
		response = { :error => "Invalid password" }.to_json
	end #if
	  
end #post '/login'

end #class end

