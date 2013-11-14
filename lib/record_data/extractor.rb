require_relative '../form'
require 'json'

class RecordData
  module Extractors
    class AddressField; end
    class ChoiceField; end
    class ClassificationField; end
    class DateTimeField; end
    class Label; end
    class PhotoField; end
    class Section; end
    class SignatureField; end
    class TextField
      def initialize(field_value)
        @field_value = field_value
      end

      def extract
        @field_value
      end
    end
    class NumericField; end
  end

  class Extractor
    def initialize(unconverted_data)
      @unconverted_data = unconverted_data
    end

    def extract
      form = Form.new(@unconverted_data['form_id'])
      form_values = JSON.parse(@unconverted_data['form_values'])
      extracted_record_data = {}

      form_values.each do |form_field_key, form_field_value|
        form_field = form.find_field_by_key(form_field_key)
        return unless form_field
        field_name = form_field['label']
        field_type = form_field['type']
        extractor_class = EXTRACTORS[field_type]
        extracted_data = extractor_class.new(form_field_value).extract
        extracted_record_data[field_name] = extracted_data
      end

      extracted_record_data
    end

  private
    EXTRACTORS =
      {
        'AddressField'        => RecordData::Extractors::AddressField,
        'ChoiceField'         => RecordData::Extractors::ChoiceField,
        'ClassificationField' => RecordData::Extractors::ClassificationField,
        'DateTimeField'       => RecordData::Extractors::DateTimeField,
        'Label'               => RecordData::Extractors::Label,
        'PhotoField'          => RecordData::Extractors::PhotoField,
        'Section'             => RecordData::Extractors::Section,
        'SignatureField'      => RecordData::Extractors::SignatureField,
        'TextField'           => RecordData::Extractors::TextField,
        'NumericField'        => RecordData::Extractors::NumericField
      }.freeze
  end
end
