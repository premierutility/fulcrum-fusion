require 'sinatra'
require 'json'
require_relative 'lib/event_processor'
require_relative 'credentials.rb' if File.exists?('credentials.rb')

set :port, ENV['PORT'] if ENV['PORT']  # Configure sinatra

get '/' do
  "Fulcrum Fusion is running"
end

post '/' do
  event_data = JSON.parse(request.body.first)

  EventProcessor.new(event_data).process
end

