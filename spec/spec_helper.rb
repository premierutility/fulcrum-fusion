# Note: Ideas from http://blog.codenursery.com/2011/11/adding-rspec-to-sinatra.html
# and http://www.iamzp.com/blog/2013/04/12/test-driven-development-with-sinatra-rspec-and-guard/
require 'rubygems'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter 'config.rb'
end

require 'sinatra'
require 'rspec'
require 'rack/test'

def require_files
  ruby_files = File.join(File.dirname(__FILE__), '..', 'lib', '**', '*.rb')
  Dir[ruby_files].each do |file|
    require file
  end
  require File.join(File.dirname(__FILE__), '..', 'fulcrum_fusion.rb')
end

require_files

ENV['RACK_ENV'] = 'test'


# Set up the test env
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  @app ||= Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  support_files = File.join(File.dirname(__FILE__), 'support', '**', '*.rb')

  Dir[support_files].each do |file|
    require file
  end

  config.before(:each) do
    EventProcessor.any_instance.stub(:puts)
  end
end

