class MyApp < Sinatra::Application

  delete '/donor/delete/:email' do
    ##TODO: needs check to see if you really want to delete the donor. perhaps put that in a get request that then redirects here?
    Donor.delete(params[:email])
  end #delete

#  get "/donor/email/:email" do
    ### AS THIS CURRENTLY STANDS IT WILL FIND AN OBJECT WITH THE VALID EMAIL AND RETURN IT'S NEO4J ID. WE SHOULD BE MOVING TOWARD THIS
    ### TYPE OF ID'ing NODES, IE, WHERE WE RELY ON THE NODE ID INSTEAD OF ANY OTHER ID
    #        	id = params[:ein]
    # look up the node by id
    #        	Donor.find_by_id(id).to_json
#    donor=Donor.find_by_email(params[:email])
#    puts "Found donor:"
#    puts "\tid: "+donor.neo_id.to_s
#    print "\temail: "+donor.email
#  end
  
  
#  get '/donor/:id' do
#    node=Neography::Node.load(params[:id])
#    puts node.neo_id
#    puts node.name
#    puts node.email                #TODO this should probably be the confirmation page for deleting a user, then it redirects to HTTP delete route
    #                yield
#  end #/donor/:email
  
  get '/donor/:email' do
	@donor=Donor.find_by_email(params[:email])
	puts @donor
  end #/donor/:email
  
#  get '/profile/:email' do
    #		TODO This is should return all the data that is part of a user's profile.
    #		including: endowment packages, contact info, any other public info
#    yield
#  end #/profile/:email
  
  
  ### The following route is semi nonfunctional, mostly because the add_property method in Donor.rb isn't correct -josh
  post '/donor/addproperty' do
    content_type :json
    data=JSON.parse(request.body.read)
    @object = Donor.find(data["email"])
    puts @object
    
    data.each do |key, value|
      if key!="email"
        @object.add_attribute(key, value)
      end
    end #do
    
  end # post /donor/addproperty
  

end

