require 'fulcrum'
require_relative '../config.rb' if File.exists?('config.rb')

class Form
  def initialize(form_id)
    @form_id = form_id
  end

  def find_field_by_key(field_key)
    return unless form_exists?

    form_elements = form_request['form']['elements']
    field_for_key = form_elements.select{|e| e['key'] == field_key}.first
  end

private
  def form_request
    unless @form_request
      configure_api

      @form_request = Fulcrum::Form.find(@form_id)
    end

    @form_request
  end

  def configure_api
    Fulcrum::Api.configure do |config|
      config.uri = ENV['FULCRUM_API_URL']
      config.key = ENV['FULCRUM_API_KEY']
    end
  end

  def form_exists?
    form_request && form_request['form']
  end
end

