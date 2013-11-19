require_relative 'schemas/address_field'
require_relative 'schemas/choice_field'
require_relative 'schemas/classification_field'
require_relative 'schemas/datetime_field'
require_relative 'schemas/label'
require_relative 'schemas/photo_field'
require_relative 'schemas/section'
require_relative 'schemas/signature_field'
require_relative 'schemas/text_field'
require_relative 'schemas/numeric_field'

class Form
  class Fields
    class Schemas
      class << self
        def [](val)
          SCHEMAS[val]
        end
      end

    private
      SCHEMAS =
        {
          'AddressField'        => Schemas::AddressField,
          'ChoiceField'         => Schemas::ChoiceField,
          'ClassificationField' => Schemas::ClassificationField,
          'DateTimeField'       => Schemas::DateTimeField,
          'Label'               => Schemas::Label,
          'PhotoField'          => Schemas::PhotoField,
          'Section'             => Schemas::Section,
          'SignatureField'      => Schemas::SignatureField,
          'TextField'           => Schemas::TextField,
          'NumericField'        => Schemas::NumericField
        }.freeze
    end
  end
end

