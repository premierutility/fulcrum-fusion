class RecordProcessor
  class Base
    def initialize(table, record_row)
      @table = table
      @record_row = record_row
    end

    def row
      @table.select("ROWID", "WHERE id='#{@record_row["id"]}'").first
    end

    def row_id
      row ? row[:rowid] : nil
    end
  end
end

