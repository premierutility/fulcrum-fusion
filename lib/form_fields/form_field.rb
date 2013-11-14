require_relative '../form/fields/schema_for_type'

class FormField
  def initialize(form_field)
    @form_field = form_field
  end

  def schema
    unless @schema
      process
    end

    @schema
  end

private

  def process
    klass = schema_type
    return unless klass

    field = klass.new(@form_field)
    @schema = field.schema
  end

  def schema_type
    Form::Fields::SchemaForType.new(@form_field).schema_class
  end
end

