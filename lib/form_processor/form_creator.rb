require_relative '../fulcrum_table'
require_relative '../form/fields'
require_relative '../status'

class FormProcessor
  class FormCreator
    def initialize(form_id, event_data)
      @form_id = form_id
      @event_data = event_data
    end

    def process
      table = FulcrumTable.new(form_name).create_table(columns)

      if table
        Status::CREATED
      else
        # Table already existed, so it wasn't created again.
        Status::ACCEPTED
      end
    end

  private
    def event_name
      @event_data['data']['name'].gsub(' ', '')
    end

    def form_name
      "FulcrumApp_#{event_name}_WithId_#{@form_id}"
    end

    def columns
      form_fields = @event_data['data']['elements']
      Form::Fields.new(form_fields).fusion_columns_schema
    end
  end
end

