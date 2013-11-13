require 'fulcrum'
require_relative '../config.rb' if File.exists?('config.rb')

class Form
  def initialize(form_id)
    @form_id = form_id
  end

  def field_key_name_mappings
    return unless form_exists?

    fields = form_request['form']['elements']
    {}.tap do |key_name_mappings|
      fields.each do |field|
        key = field['key']
        name = field['label']

        key_name_mappings[key] = name
      end
    end
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

