class RecordProcessor
  class RecordUpdater < Base
    def process
      if row_id
        begin
          @table.update(row_id, fusion_record)
        rescue StandardError => e
          if column_doesnt_exist_error?(e)
            begin
              @table.update(row_id, raw_record)

            rescue StandardError
              return Status::INTERNAL_ERROR

            else
              return Status::NO_CONTENT
            end
          end
          return Status::INTERNAL_ERROR

        else
          return Status::NO_CONTENT
        end

      else
        return Status::ACCEPTED
      end
    end
  end
end

