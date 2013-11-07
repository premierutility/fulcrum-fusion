class FormFields
  def initialize(form_fields)
    @form_fields = form_fields
  end

  def fusion_columns_schema
    FusionColumnsSchema.new(@form_fields).schema
  end
end

class FusionColumnsSchema
  def initialize(form_fields)
    @form_fields = form_fields
  end

  def schema
    unless @columns_schema
      @columns_schema =
        @form_fields.flat_map do |form_field|
          FormField.new(form_field).schema
        end

      class << @columns_schema
        def remove_nils!
          self.select!{|schema| !schema.nil? }
        end
      end

      @columns_schema.remove_nils!
    end

    @columns_schema
  end
end

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

class TextField < FieldBase
private
  def type
    DATA_TYPES[:string]
  end
end

class NumericField < FieldBase
private
  def type
    DATA_TYPES[:number]
  end
end

class Label < FieldBase
  def schema
  end
end

class ChoiceField < TextField; end
class ClassificationField < TextField; end
class PhotoField < TextField; end
class DateTimeField < TextField; end
class AddressField < TextField; end
class SignatureField < TextField; end
class Section < FieldBase
  def schema
    return nil unless @form_field && @form_field['elements']

    section_name = @form_field['label']
    section_elements = @form_field['elements']

    temp_schema =
      FormFields.new(section_elements).fusion_columns_schema

    temp_schema.each do |column_schema|
      column_schema[:name] = "#{section_name} - #{column_schema[:name]}"
    end
  end
end

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

