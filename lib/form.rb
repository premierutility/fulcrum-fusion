require 'fulcrum'
require_relative '../config.rb' if File.exists?('config.rb')

class Form
  def initialize(form_id)
    @form_id = form_id
  end

  def field_key_name_mappings
    configure_api

    request = Fulcrum::Form.find(@form_id)
    return unless form_exists?(request)

    fields = request['form']['elements']
    {}.tap do |key_name_mappings|
      fields.each do |field|
        key = field['key']
        name = field['label']

        key_name_mappings[key] = name
      end
    end
  end

private
  def configure_api
    Fulcrum::Api.configure do |config|
      config.uri = ENV['FULCRUM_API_URL']
      config.key = ENV['FULCRUM_API_KEY']
    end
  end

  def form_exists?(request)
    request && request['form']
  end
end

