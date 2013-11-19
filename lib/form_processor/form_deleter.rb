require_relative '../fulcrum_table'
require_relative '../status'

class FormProcessor
  class FormDeleter
    def initialize(form_id)
      @form_id = form_id
    end

    def process
      table = FulcrumTable.new(@form_id).drop_table

      if table
        Status::NO_CONTENT
      else
        # Table doesn't exist, so it couldnt' be deleted.
        Status::ACCEPTED
      end
    end
  end
end

