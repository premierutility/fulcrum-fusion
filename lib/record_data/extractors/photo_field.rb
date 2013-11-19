require_relative 'base'

class RecordData
  class Extractors
    class PhotoField < Base
      def extract
        urls = @field_value.map{|p| p['url']}
        urls.join(' ')
      end
    end
  end
end

