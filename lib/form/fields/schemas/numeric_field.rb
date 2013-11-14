require_relative '../../../form_fields/field_base'

class Form
  class Fields
    class Schemas
      class NumericField < FieldBase
      private
        def type
          DATA_TYPES[:number]
        end
      end
    end
  end
end

