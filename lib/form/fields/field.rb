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
        klass = schema_type ? schema_type : Schemas['TextField']

        field = klass.new(@form_field)
        @schema = field.schema
      end

      def schema_type
        @schema_type ||=
          Form::Fields::SchemaForType.new(@form_field).schema_class
      end
    end
  end
end

