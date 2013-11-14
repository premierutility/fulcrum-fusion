require_relative '../../../form_fields/field_base'

class Form
  class Fields
    class Schemas
      class TextField < FieldBase
      private
        def type
          DATA_TYPES[:string]
        end
      end
    end
  end
end

