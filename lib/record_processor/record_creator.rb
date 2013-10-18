class RecordProcessor
  class RecordCreator < Base
    def process
      @table.insert([@record_row])
      201
    end
  end
end

