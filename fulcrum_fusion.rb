require 'sinatra'
require 'json'
require 'yaml'
require 'fusion_tables'
require './event_processor'

set :port, 3002 # Configure sinatra

get '/' do
  "Fulcrum Fusion is running"
end

post '/' do
  event_data = JSON.parse(request.body.first)

  EventProcessor.new.process(event_data)
end

