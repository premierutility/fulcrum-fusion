require_relative '../fulcrum_table'
require_relative '../status'

class FormProcessor
  class FormUpdater
    def process
      # Not sure if we can update anything with this fusion_tables library.
      Status::ACCEPTED
    end
  end
end

