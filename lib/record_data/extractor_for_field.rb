require_relative 'extractors/address_field'
require_relative 'extractors/choice_field'
require_relative 'extractors/classification_field'
require_relative 'extractors/date_time_field'
require_relative 'extractors/photo_field'
require_relative 'extractors/section'
require_relative 'extractors/signature_field'
require_relative 'extractors/text_field'
require_relative 'extractors/numeric_field'

class RecordData
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
        'AddressField'        => Extractors::AddressField,
        'ChoiceField'         => Extractors::ChoiceField,
        'ClassificationField' => Extractors::ClassificationField,
        'DateTimeField'       => Extractors::DateTimeField,
        'PhotoField'          => Extractors::PhotoField,
        'Section'             => Extractors::Section,
        'SignatureField'      => Extractors::SignatureField,
        'TextField'           => Extractors::TextField,
        'NumericField'        => Extractors::NumericField
      }.freeze
  end
end

