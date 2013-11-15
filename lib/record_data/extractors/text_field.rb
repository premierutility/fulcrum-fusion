require_relative 'base'

class RecordData
  module Extractors
    class TextField < Base
      def extract
        @field_value
      end
    end
  end
end

