require_relative 'base'

class Form
  class Fields
    class Schemas
      class NumericField < Base
      private
        def type
          DATA_TYPES[:number]
        end
      end
    end
  end
end

