require 'sinatra'
require 'json'
require_relative 'lib/event_processor'
require_relative 'config.rb' if File.exists?('config.rb')

set :port, ENV['PORT'] if ENV['PORT']  # Configure sinatra

get '/' do
  "Fulcrum Fusion is running"
end

post '/' do
  event_data = JSON.parse(request.body.first)

  EventProcessor.new(event_data).process
end

