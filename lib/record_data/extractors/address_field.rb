require_relative 'text_field'

class RecordData
  class Extractors
    class AddressField < TextField
      def extract
        number   = @field_value['sub_thoroughfare']
        street   = @field_value['thoroughfare']
        suite    = @field_value['suite']
        city     = @field_value['locality']
        state    = @field_value['admin_area']
        zip_code = @field_value['postal_code']

        street_portion = "#{number} #{street} #{suite}"
        city_portion   = "#{city}, #{state} #{zip_code}"

        "#{street_portion}, #{city_portion}"
      end
    end
  end
end

