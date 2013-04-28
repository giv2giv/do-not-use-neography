class App < Sinatra::Application

  delete '/donor/delete/:email' do
    ##TODO: needs check to see if you really want to delete the donor. perhaps put that in a get request that then redirects here?
    Donor.delete(params[:email])
  end #delete

## Curl commands to server take this general format, replacing the url suffix and ROUTE as needed
## curl -i -H "Accept: application/json" -X DELETE http://localhost:9393/donor/1 -d ''



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
  

  
  put '/donor/:email' do
	content_type :json
	data=Json.parse(request.body.read)
	@donor=Donor.create()

  end

  get '/donor/:email' do
	@donor=Donor.find_by_email(params[:email])
	puts @donor
	puts @donor.name
	puts @donor.email
	puts Donor.name
  end #/donor/:email

  delete '/donor/:email' do
	@donor=Donor.find_by_email(params[:email])
	puts @donor
	@donor.del
	puts @donor
  end



  

  ### The following route is semi nonfunctional, mostly because the add_property method in Donor.rb isn't correct -josh
  put '/donor/:email/:property/:value' do
#    content_type :json
#    data=JSON.parse(request.body.read)
    @object = Donor.find_by_email(params[:email])
    puts @object
	prop=params[:property]
	@object[prop]=params[:value]
	puts @object
    end #do
    
#  end # post /donor/addproperty
  

end

