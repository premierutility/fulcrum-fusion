require 'fulcrum'
require_relative '../config.rb' if File.exists?('config.rb')

class FormFields
  def initalize(form_fields)
    @form_fields = form_fields
  end

  def fusion_column_schema
    @form_fields = @form_fields.dup

    class << @form_fields
      def extract_column_info
        map!{|e| [e["key"], e["label"]]}
      end

      def sort_alphabetically
        sort!{|a,b| a[1] <=> b[1]}
      end

      def map_to_fusion_schema
        map!{|e| {name: e[1], type: "string"} }
      end
    end

    @form_fields.
      extract_column_info.
      sort_alphabetically.
      map_to_fusion_schema
  end

  def self.get_form_columns(form_id)
    configure_api

    request = Fulcrum::Form.find(form_id)
    return unless request && request['form']
    elements = request['form']['elements']
    {}.tap do |h|
      elements.map {|e| h[e['key']] = e['label'] }
    end
  end

private
  def self.configure_api
    Fulcrum::Api.configure do |config|
      config.uri = ENV['FULCRUM_API_URL']
      config.key = ENV['FULCRUM_API_KEY']
    end
  end
end

