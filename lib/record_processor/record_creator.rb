require_relative '../status'

class RecordProcessor
  class RecordCreator < Base
    def process
      return Status::ACCEPTED if row_already_exists?

      begin
        @table.insert([fusion_record])

      rescue StandardError => e
        if column_doesnt_exist_error?(e)
          begin
            @table.insert([raw_record])

          rescue StandardError
            return Status::INTERNAL_ERROR

          else
            return Status::CREATED
          end
        end
        return Status::INTERNAL_ERROR

      else
        return Status::CREATED
      end
    end

  private
    def row_already_exists?
      !!row
    end
  end
end

