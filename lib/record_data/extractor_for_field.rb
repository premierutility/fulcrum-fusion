require_relative 'extractors'

class RecordData
  class ExtractorForField
    def initialize(field_type, numeric)
      @field_type = field_type
      @numeric    = numeric
    end

    def extractor_class
      if numeric_field?
        Extractors['NumericField']

      else
        Extractors[@field_type]
      end
    end

  private
    def numeric_field?
      @field_type == 'TextField' && @numeric
    end

  end
end

