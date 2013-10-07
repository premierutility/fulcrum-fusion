require_relative '../fulcrum_table'

class FormProcessor
  class FormDeleter
    def initialize(form_id)
      @form_id = form_id
    end

    def process
      table = FulcrumTable.new.drop_table(@form_id)

      if table
        204 # No Content
      else
        # Table doesn't exist, so it couldnt' be deleted.
        202 # Accepted
      end
    end
  end
end
