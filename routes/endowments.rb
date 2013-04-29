# Begin endowments
class App < Sinatra::Application
  # Create a new endowment
  post '/endowment/new' do
    content_type :json
    data=JSON.parse(request.body.read)
    Endowment.create(session[:id], data['name'], data['amount'], data['frequency']).to_json
  end
  
  # endowment modified, add new investment fund
  get '/endowment/:endowment_id/add_investment_fund/:fund_id' do
    content_type :json
    Endowment.add_investment_fund(params[:endowment_id]).to_json  
  end
  
  # endowment modified, add new charity to grantees
  get '/endowment/:endowment_id/add_charity/:charity_id' do
    content_type :json
    Endowment.add_charity(params[:endowment_id], params[:charity_id]).to_json
  end
  
  # session donor signs up to contribute to an endowment
  get '/endowment/:endowment_id/add_donor' do
    content_type :json
    Endowment.add_donor(params[:endowment_id]).to_json
  end
end


