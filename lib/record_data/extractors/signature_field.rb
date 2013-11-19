require_relative 'base'

class RecordData
  class Extractors
    class SignatureField < Base
      def extract
        @field_value['url']
      end
    end
  end
end

