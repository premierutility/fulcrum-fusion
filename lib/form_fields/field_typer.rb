require_relative '../form/fields/types'

class FieldTyper
  def initialize(form_field)
    @form_field = form_field
  end

  def type
    type_text = @form_field['type']

    if numeric_field?(type_text)
      numeric_field
    else
      Form::Fields::Types[type_text]
    end
  end

private
  def numeric_field?(type_text)
    type_text == 'TextField' && @form_field['numeric']
  end

  def numeric_field
    Form::Fields::Types['NumericField']
  end
end
