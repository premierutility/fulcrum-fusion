require 'fulcrum'
require_relative '../config.rb' if File.exists?('config.rb')

class Form
  def initialize(form_id)
    @form_id = form_id
  end

  def field_key_name_mappings
    configure_api

    request = Fulcrum::Form.find(form_id)
    return unless request && request['form']
    elements = request['form']['elements']
    {}.tap do |h|
      elements.map {|e| h[e['key']] = e['label'] }
    end
  end

private
  def configure_api
    Fulcrum::Api.configure do |config|
      config.uri = ENV['FULCRUM_API_URL']
      config.key = ENV['FULCRUM_API_KEY']
    end
  end
end
