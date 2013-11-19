require_relative 'schema_for_type'
require_relative 'schemas'

class Form
  class Fields
    class Field
      def initialize(form_field)
        @form_field = form_field
      end

      def schema
        unless @schema
          process
        end

        @schema
      end

    private
      def process
        klass = schema_type

        field = klass.new(@form_field)
        @schema = field.schema
      end

      def schema_type
        unless @schema_type
          schema_class = Form::Fields::SchemaForType.new(@form_field).schema_class
          default_schema = Schemas['TextField']
          @schema_type = schema_class ? schema_class : default_schema
        end

        @schema_type
      end
    end
  end
end

