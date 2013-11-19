require_relative 'text_field'

class Form
  class Fields
    class Schemas
      class DateTimeField < TextField
        def type
          DATA_TYPES[:datetime]
        end
      end
    end
  end
end

