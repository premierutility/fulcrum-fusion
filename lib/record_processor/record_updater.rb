class RecordProcessor
  class RecordUpdater < Base
    def process
      if row_id
        @table.update(row_id, @record_row)
        200
      else
        204
      end
    end
  end
end
