# Idea taken from: https://github.com/daddz/sinatra-rspec-bundler-template/blob/master/config/boot.rb
ENV['RACK_ENV'] ||= 'development'

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

