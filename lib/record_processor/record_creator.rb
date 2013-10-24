class RecordProcessor
  class RecordCreator < Base
    def process
      return if row_already_exists?

      begin
        @table.insert([fusion_record])
      rescue ArgumentError => e
        if column_doesnt_exist_error?(e)
          @table.insert([raw_record])
        end
      end
      201
    end

  private
    def row_already_exists?
      row
    end
  end
end

