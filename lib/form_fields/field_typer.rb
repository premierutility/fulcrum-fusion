require_relative 'address_field'
require_relative 'choice_field'
require_relative 'classification_field'
require_relative 'datetime_field'
require_relative 'label'
require_relative 'photo_field'
require_relative 'section'
require_relative 'signature_field'
require_relative 'text_field'
require_relative 'numeric_field'

class FieldTyper
  def initialize(form_field)
    @form_field = form_field
  end

  def type
    type_text = @form_field['type']

    if numeric_field?(type_text)
      numeric_field
    else
      FIELD_TYPES[type_text]
    end
  end

private
  FIELD_TYPES =
    {
      'AddressField'        => AddressField,
      'ChoiceField'         => ChoiceField,
      'ClassificationField' => ClassificationField,
      'DateTimeField'       => DateTimeField,
      'Label'               => Label,
      'PhotoField'          => PhotoField,
      'Section'             => Section,
      'SignatureField'      => SignatureField,
      'TextField'           => TextField,
      'NumericField'        => NumericField
    }.freeze

  def numeric_field?(type_text)
    type_text == 'TextField' && @form_field['numeric']
  end

  def numeric_field
    FIELD_TYPES['NumericField']
  end
end

