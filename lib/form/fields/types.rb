require_relative '../../form_fields/address_field'
require_relative '../../form_fields/choice_field'
require_relative '../../form_fields/classification_field'
require_relative '../../form_fields/datetime_field'
require_relative '../../form_fields/label'
require_relative '../../form_fields/photo_field'
require_relative '../../form_fields/section'
require_relative '../../form_fields/signature_field'
require_relative '../../form_fields/text_field'
require_relative '../../form_fields/numeric_field'

class Fields
  class Types
    class << self
      def [](val)
        TYPES[val]
      end
    end
  end

private
  TYPES =
    {
      'AddressField'        => ::AddressField,
      'ChoiceField'         => ::ChoiceField,
      'ClassificationField' => ::ClassificationField,
      'DateTimeField'       => ::DateTimeField,
      'Label'               => ::Label,
      'PhotoField'          => ::PhotoField,
      'Section'             => ::Section,
      'SignatureField'      => ::SignatureField,
      'TextField'           => ::TextField,
      'NumericField'        => ::NumericField
    }.freeze
end
