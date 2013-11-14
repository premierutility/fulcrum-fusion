class RecordData
  module Extractors
    class TextField
      def initialize(field_value)
        @field_value = field_value
      end

      def extract
        @field_value
      end
    end
  end
end

