require_relative 'field'

class Form
  class Fields
    class FusionColumnsSchema
      def initialize(form_fields)
        @form_fields = form_fields
      end

      def schema
        unless @columns_schema
          @columns_schema =
            @form_fields.flat_map do |form_field|
              Form::Fields::Field.new(form_field).schema
            end

          class << @columns_schema
            def remove_nils!
              self.select!{|schema| !schema.nil? }
            end
          end

          @columns_schema.remove_nils!
        end

        @columns_schema
      end
    end
  end
end

