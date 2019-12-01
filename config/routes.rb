Rails.application.routes.draw do
  get '/no9527/eat', to: 'no9527#eat'
  get '/no9527/request_headers', to: 'no9527#request_headers'
  get '/no9527/request_body', to: 'no9527#request_body'
  get '/no9527/response_headers', to: 'no9527#response_headers'
  get '/no9527/response_body', to: 'no9527#show_response_body'
  
  get '/no9527/sent_request', to: 'no9527#sent_request'
  
  post '/no9527/webhook', to: 'no9527#webhook'
  
  get '/no9527/get_weather', to: 'no9527#get_weather'
end
