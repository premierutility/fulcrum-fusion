class FieldBase
  def initialize(form_field)
    @form_field = form_field
  end

  def schema
    { :name => @form_field['label'], :type => type } if type
  end

private
  DATA_TYPES =
    {
      number: 'number',
      string: 'string',
      location: 'location',
      datetime: 'datetime'
    }.freeze
end

