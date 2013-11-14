require_relative 'schemas/address_field'
require_relative 'schemas/choice_field'
require_relative 'schemas/classification_field'
require_relative '../../form_fields/datetime_field'
require_relative '../../form_fields/label'
require_relative '../../form_fields/photo_field'
require_relative '../../form_fields/section'
require_relative '../../form_fields/signature_field'
require_relative '../../form_fields/text_field'
require_relative '../../form_fields/numeric_field'

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
          'DateTimeField'       => ::DateTimeField,
          'Label'               => ::Label,
          'PhotoField'          => ::PhotoField,
          'Section'             => ::Section,
          'SignatureField'      => ::SignatureField,
          'TextField'           => ::TextField,
          'NumericField'        => ::NumericField
        }.freeze
    end
  end
end

