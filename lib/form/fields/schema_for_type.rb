require_relative 'schemas'

class Form
  class Fields
    class SchemaForType
      def initialize(form_field)
        @form_field = form_field
      end

      def schema_class
        type_text = @form_field['type']

        if numeric_field?(type_text)
          numeric_field

        else
          Schemas[type_text]
        end
      end

    private
      def numeric_field?(type_text)
        type_text == 'TextField' && @form_field['numeric']
      end

      def numeric_field
        Schemas['NumericField']
      end
    end
  end
end

