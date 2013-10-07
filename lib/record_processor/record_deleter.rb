class RecordProcessor
  class RecordDeleter
    def initialize(table, record_row)
      @table = table
      @record_row = record_row
    end

    def process
      row = @table.select("ROWID", "WHERE id='#{@record_row["id"]}'").first
      row_id = row ? row[:rowid] : nil
      if row_id
        @table.delete(row_id)
        204
      else
        202
      end
    end
  end
end
