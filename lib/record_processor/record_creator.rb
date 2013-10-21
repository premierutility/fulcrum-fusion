class RecordProcessor
  class RecordCreator < Base
    def process
      return if row_already_exists?
      @table.insert([@record_row])
      201
    end

    def row_already_exists?
      row
    end
  end
end

