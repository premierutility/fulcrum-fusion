require_relative '../../../form_fields/field_base'

class Form
  class Fields
    class Schemas
      class Section < FieldBase
        def schema
          return nil unless @form_field && @form_field['elements']

          section_name = @form_field['label']
          section_elements = @form_field['elements']

          temp_schema =
            FormFields.new(section_elements).fusion_columns_schema

          temp_schema.each do |column_schema|
            column_schema[:name] = "#{section_name} - #{column_schema[:name]}"
          end
        end
      end
    end
  end
end

