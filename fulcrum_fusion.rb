require 'sinatra'
require 'json'
require 'yaml'
require_relative 'lib/event_processor'

set :port, 3002 # Configure sinatra

get '/' do
  "Fulcrum Fusion is running"
end

post '/' do
  event_data = JSON.parse(request.body.first)

  EventProcessor.new(event_data).process
end

