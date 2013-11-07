require_relative 'field_typer'

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
    klass = field_type
    return unless klass

    field = klass.new(@form_field)
    @schema = field.schema
  end

  def field_type
    FieldTyper.new(@form_field).type
  end
end

