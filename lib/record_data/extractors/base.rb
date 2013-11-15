class RecordData
  module Extractors
    class Base
      def initialize(form_field, field_value)
        @form_field = form_field
        @field_value = field_value
      end
    end
  end
end
