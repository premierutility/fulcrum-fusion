require_relative 'base'

class Form
  class Fields
    class Schemas
      class Section < Base
        def schema
          return nil unless @form_field && @form_field['elements']

          section_elements = @form_field['elements']

          Form::Fields.new(section_elements).fusion_columns_schema
        end
      end
    end
  end
end

