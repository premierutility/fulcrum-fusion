require_relative '../status'

class RecordProcessor
  class RecordDeleter < Base
    def process
      if row_id
        @table.delete(row_id)
        Status::NO_CONTENT
      else
        Status::ACCEPTED
      end
    end
  end
end

