class RecordUpdater
  def initialize(table, record_row)
    @table = table
    @record_row = record_row
  end

  def process
    row = @table.select("ROWID", "WHERE id='#{@record_row["id"]}'").first
    row_id = row ? row[:rowid] : nil
    if row_id
      @table.update(row_id, @record_row)
      200
    else
      204
    end
  end
end
