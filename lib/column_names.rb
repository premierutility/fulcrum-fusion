require 'fulcrum'
require_relative 'credentials'

class ColumnNames
  def self.from_form(columns_data)
    columns_data.
      map{|e| [e["key"], e["label"]] }.
      sort{|a,b| a[0] <=> b[0]}.
      map{|e| {name: e[1], type: "string"} }
  end

  def self.get_form_columns(form_id)
    configure_api

    form = Fulcrum::Form.find(form_id)['form']
    elements = form['elements']
    {}.tap do |h|
      elements.map {|e| h[e['key']] = e['label'] }
    end
  end

private
  def self.configure_api
    Fulcrum::Api.configure do |config|
      config.uri = 'https://api.fulcrumapp.com/api/v2'
      config.key = Credentials.new.fulcrum_api_key
    end
  end
end
