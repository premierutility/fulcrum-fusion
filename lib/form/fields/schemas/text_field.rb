require_relative 'base'

class Form
  class Fields
    class Schemas
      class TextField < Base
      private
        def type
          DATA_TYPES[:string]
        end
      end
    end
  end
end

