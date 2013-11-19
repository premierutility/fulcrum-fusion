require_relative 'extractors/address_field'
require_relative 'extractors/choice_field'
require_relative 'extractors/classification_field'
require_relative 'extractors/date_time_field'
require_relative 'extractors/photo_field'
require_relative 'extractors/signature_field'
require_relative 'extractors/text_field'
require_relative 'extractors/numeric_field'

class RecordData
  class Extractors
      class << self
        def [](val)
          EXTRACTORS[val]
        end
      end
    private

    EXTRACTORS =
      {
        'AddressField'        => Extractors::AddressField,
        'ChoiceField'         => Extractors::ChoiceField,
        'ClassificationField' => Extractors::ClassificationField,
        'DateTimeField'       => Extractors::DateTimeField,
        'PhotoField'          => Extractors::PhotoField,
        'SignatureField'      => Extractors::SignatureField,
        'TextField'           => Extractors::TextField,
        'NumericField'        => Extractors::NumericField
      }.freeze
  end
end
