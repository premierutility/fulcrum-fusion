class RecordProcessor
  class RecordUpdater < Base
    def process
      if row_id
        begin
          @table.update(row_id, fusion_record)
        rescue ArgumentError => e
          if column_doesnt_exist_error?(e)
            @table.update(row_id, raw_record)
          end
        end
        200
      else
        204
      end
    end
  end
end

