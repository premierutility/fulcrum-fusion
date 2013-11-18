class Form
  class Fields
    class Schemas
      class Base
        def initialize(form_field)
          @form_field = form_field
        end

        def schema
          { :name => @form_field['data_name'], :type => type } if type
        end

      private
        DATA_TYPES =
          {
            number: 'number',
            string: 'string',
            location: 'location',
            datetime: 'datetime'
          }.freeze
      end
    end
  end
end
