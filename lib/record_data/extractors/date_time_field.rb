class RecordData
  class Extractors
    class DateTimeField < Base
      def extract
        DateTime.parse @field_value
      end
    end
  end
end

