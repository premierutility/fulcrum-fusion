class RecordProcessor
  class RecordDeleter < Base
    def process
      if row_id
        @table.delete(row_id)
        204
      else
        202
      end
    end
  end
end
