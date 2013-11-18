class RecordData
  module Extractors
    class DateTimeField < Base
      def extract
        DateTime.parse @field_value
      end
    end
  end
end

