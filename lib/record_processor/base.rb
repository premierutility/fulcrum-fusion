class RecordProcessor
  class Base
    def initialize(table, record_data)
      @table = table
      @record_data = record_data
    end

    def fusion_record
      @record_data.fusion_format
    end

    def raw_record
      @record_data.raw_format
    end

    def row
      record_id = @record_data.raw_format['id']
      @table.
        select("ROWID",
               "WHERE id='#{record_id}'").
        first
    end

    def row_id
      row ? row[:rowid] : nil
    end

  private
    def column_doesnt_exist_error?(e)
      e.class == ArgumentError &&
        e.message.match(Regexp.new("The column doesn't exist"))
    end
  end
end

