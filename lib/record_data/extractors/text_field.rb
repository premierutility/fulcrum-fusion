require_relative 'base'

class RecordData
  class Extractors
    class TextField < Base
      def extract
        @field_value
      end
    end
  end
end

