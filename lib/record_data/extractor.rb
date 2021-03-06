require_relative '../form'
require_relative 'field'
require 'json'

class RecordData
  class Extractor
    def initialize(fulcrum_form, unconverted_data)
      @fulcrum_form = fulcrum_form
      @unconverted_data = unconverted_data
    end

    def extract
      extracted_record_data = {}

      form_values.each do |field_key, field_value|
        field = Field.new(@fulcrum_form, field_key, field_value)
        extracted_record_data[field.name] = field.extracted_data
      end

      extracted_record_data
    end

  private
    def form_values
      @form_values ||= JSON.parse(@unconverted_data['form_values'])
    end
  end
end

