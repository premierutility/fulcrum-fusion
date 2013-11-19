class RecordData
  class Extractors
    class UnknownField < Base
      def extract
        @field_value.to_json
      end
    end
  end
end

