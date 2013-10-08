require_relative '../fulcrum_table'
require_relative '../column_names'

class FormProcessor
  class FormCreator
    def initialize(form_id, event_data)
      @form_id = form_id
      @event_data = event_data
    end

    def process
      table = FulcrumTable.new.create_table(form_name, columns)

      if table
        201 # Created
      else
        # Table already existed, so it wasn't created again.
        202 # Accepted
      end
    end

  private
    def event_name
      @event_data["data"]["name"].gsub(" ", "")
    end

    def form_name
      "FulcrumApp_#{event_name}_WithId_#{@form_id}"
    end

    def columns
      ColumnNames.from_form(@event_data["data"]["elements"])
    end
  end
end
