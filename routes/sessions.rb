class App < Sinatra::Application

#We want to do something like:
#https://gist.github.com/amscotti/1384524

post "/signup" do

	puts "Post to /donor/new or /charities/new"
end


post '/login' do
	content_type :json
	data=JSON.parse(request.body.read)

	login_node = Donor.find_by_email(data["email"])
	  
	if login_node.nil?

		login_node = Charity.find_by_email(data["email"])

		if login_node.nil?
			response = { :error => "Login email not found" }.to_json
		end
	    
	elsif data["password"] == BCrypt::Password.new(login_node.password)
		session[:email] = data["email"]
		session[:id] = data["id"]
		response = { :id =>login_node.id, :email => login_node.email, :password => login_node.password }.to_json
	else
		response = { :error => "Invalid password" }.to_json
	end #if
	  
end #post '/login'

end #class end

