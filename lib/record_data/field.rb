require_relative 'extractor_for_field'

class RecordData
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
end
