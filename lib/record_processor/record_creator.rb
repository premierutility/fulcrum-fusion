class RecordProcessor
  class RecordCreator
    def initialize(table, record_row)
      @table = table
      @record_row = record_row
    end

    def process
      @table.insert([@record_row])
      201
    end
  end
end
