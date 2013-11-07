require 'sinatra'
require 'json'
require_relative 'lib/status'
require_relative 'lib/event_data'
require_relative 'lib/event_processor'
require_relative 'config.rb' if File.exists?('config.rb')

set :port, ENV['PORT'] if ENV['PORT']  # Configure sinatra

get '/' do
  "Fulcrum Fusion is running"
end

post '/' do
  request.body.rewind
  post_body = request.body.read

  begin
    event_data = EventData.new(post_body).read

  rescue TypeError, EventData::BadDataError
    return Status::BAD_REQUEST
  end

  begin
    EventProcessor.new(event_data).process

  rescue TypeError, ArgumentError
    return Status::BAD_REQUEST
  end
end

