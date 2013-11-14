require_relative '../form'
require_relative 'extractors/address_field'
require_relative 'extractors/choice_field'
require_relative 'extractors/classification_field'
require_relative 'extractors/date_time_field'
require_relative 'extractors/photo_field'
require_relative 'extractors/section'
require_relative 'extractors/signature_field'
require_relative 'extractors/text_field'
require 'json'

class RecordData
  module Extractors
    class NumericField < TextField; end
  end

  class ExtractorForField
    def initialize(field_type, numeric)
      @field_type = field_type
      @numeric    = numeric
    end

    def extractor_class
      if numeric_field?
        EXTRACTORS['NumericField']

      else
        EXTRACTORS[@field_type]
      end
    end

  private
    def numeric_field?
      @field_type == 'TextField' && @numeric
    end

    EXTRACTORS =
      {
        'AddressField'        => RecordData::Extractors::AddressField,
        'ChoiceField'         => RecordData::Extractors::ChoiceField,
        'ClassificationField' => RecordData::Extractors::ClassificationField,
        'DateTimeField'       => RecordData::Extractors::DateTimeField,
        'PhotoField'          => RecordData::Extractors::PhotoField,
        'Section'             => RecordData::Extractors::Section,
        'SignatureField'      => RecordData::Extractors::SignatureField,
        'TextField'           => RecordData::Extractors::TextField,
        'NumericField'        => RecordData::Extractors::NumericField
      }.freeze
  end

  class Field
    def initialize(form, field_key, field_value)
      @form = form
      @field_key = field_key
      @field_value = field_value
    end

    def extracted_data
      return unless form_field

      extractor_class.new(@field_value).extract
    end

    def name
      form_field['label']
    end

  private
    def form_field
      unless @form_field
        @form_field = @form.find_field_by_key(@field_key)
      end

      @form_field
    end

    def type
      form_field['type']
    end

    def extractor_class
      ExtractorForField.new(type, form_field['numeric']).extractor_class
    end
  end

  class Extractor
    def initialize(unconverted_data)
      @unconverted_data = unconverted_data
    end

    def extract
      extracted_record_data = {}

      form_values.each do |field_key, field_value|
        field = Field.new(form, field_key, field_value)
        extracted_record_data[field.name] = field.extracted_data
      end

      extracted_record_data
    end

  private
    def form
      Form.new(@unconverted_data['form_id'])
    end

    def form_values
      JSON.parse(@unconverted_data['form_values'])
    end
  end
end
