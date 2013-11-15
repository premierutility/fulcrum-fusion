require_relative 'base'

class RecordData
  module Extractors
    class SignatureField < Base
      def extract
        @field_value['url']
      end
    end
  end
end

