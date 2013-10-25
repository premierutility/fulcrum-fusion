require 'fulcrum'
require_relative '../config.rb' if File.exists?('config.rb')

class FormFields
  def self.get_key_name_mapping(form_id)
    configure_api

    request = Fulcrum::Form.find(form_id)
    return unless request && request['form']
    elements = request['form']['elements']
    {}.tap do |h|
      elements.map {|e| h[e['key']] = e['label'] }
    end
  end

  def initialize(form_fields)
    @form_fields = form_fields
  end

  def fusion_columns_schema
    FusionColumnsSchema.new(@form_fields).schema
  end

private
  def self.configure_api
    Fulcrum::Api.configure do |config|
      config.uri = ENV['FULCRUM_API_URL']
      config.key = ENV['FULCRUM_API_KEY']
    end
  end
end

class FusionColumnsSchema
  def initialize(form_fields)
    @columns_schema =
      form_fields.map do |form_field|
        FormField.new(form_field).schema
      end

    class << @columns_schema
      def remove_nils
        self.select!{|schema| !schema.nil? }
      end
    end

    @columns_schema.remove_nils
  end

  def schema
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

class AddressField < TextField; end
class ChoiceField < TextField; end
class ClassificationField < TextField; end
class DateTimeField < TextField; end
class EnumerableField < TextField; end
class Label < FieldBase
  def schema
  end
end
class PhotoField < TextField; end
class Section < TextField; end
class SignatureField < TextField; end

class FieldTyper
  def initialize(form_field)
    @form_field = form_field
  end

  def type
    type = FIELD_TYPES[@form_field['type']]

    if numeric_field?(type)
      type = numeric_field
    end
    type
  end

private
  FIELD_TYPES =
    {
      'AddressField' => AddressField,
      'ChoiceField'  => ChoiceField,
      'ClassificationField' => ClassificationField,
      'DateTimeField' => DateTimeField,
      'EnumerableField' => EnumerableField,
      'Label' => Label,
      'PhotoField' => PhotoField,
      'Section' => Section,
      'SignatureField' => SignatureField,
      'TextField' => TextField,
      'NumericField' => NumericField
    }.freeze

  def numeric_field?(type)
    type == TextField && @form_field['numeric']
  end

  def numeric_field
    FIELD_TYPES['NumericField']
  end
end

