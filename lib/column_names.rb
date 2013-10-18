require 'fulcrum'

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
    return unless form
    elements = form['elements']
    {}.tap do |h|
      elements.map {|e| h[e['key']] = e['label'] }
    end
  end

private
  def self.configure_api
    Fulcrum::Api.configure do |config|
      config.uri = 'https://api.fulcrumapp.com/api/v2'
      config.uri = 'http://localhost:3000/api/v2'# TODO: For testing, set this to localhost!
      config.key = ENV['FULCRUM_API_KEY']
    end
  end
end

