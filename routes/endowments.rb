# Begin endowments
class App < Sinatra::Application

  get '/endowment/:endowment_id' do
	content_type :json
	Endowment.find(params[:endowment_id]).to_json
  end

  # Create a new endowment
  post '/endowment/new' do
	data=JSON.parse(request.body.read)

	content_type :json
	Endowment.create(session[:id], data['name'], data['amount'], data['frequency']).to_json
  end

  # endowment modified, add new investment fund
  post '/endowment/:endowment_id/add_investment_fund' do
	data=JSON.parse(request.body.read)

	content_type :json
	Endowment.add_investment_fund(data['endowment_id']).to_json  
  end
  
  # endowment modified, add new charity to grantees
  post '/endowment/:endowment_id/add_charity' do
	data=JSON.parse(request.body.read)

	content_type :json
	Endowment.add_charity(params[:endowment_id], data['charity_id']).to_json
  end

  delete '/endowment/:endowment_id' do
	Endowment.delete(params[:endowment_id]).to_json
  end
  
end


