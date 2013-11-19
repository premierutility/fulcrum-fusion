require_relative 'base'

class RecordData
  class Extractors
    class ChoiceField < Base
      def extract
        choices = @field_value['choice_values']
        others = @field_value['other_values']
        all_choices = choices.concat(others)
        all_choices.join(', ')
      end
    end
  end
end

