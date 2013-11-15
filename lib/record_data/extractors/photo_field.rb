require_relative 'base'

class RecordData
  module Extractors
    class PhotoField < Base
      def extract
        urls = @field_value.map{|p| p['url']}
        urls.join(' ')
      end
    end
  end
end

