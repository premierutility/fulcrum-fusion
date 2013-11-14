require_relative 'form_fields'
require_relative 'form'
require_relative 'record_column_sanitizer'
require 'json'

class RecordData
  def initialize(record_hash)
    @record_hash = record_hash
  end

  def fusion_format
    unless @fusion
      @fusion = raw_format
      add_form_fields_as_keys
    end

    @fusion
  end

  def raw_format
    unless @raw
      to_raw_format
    end

    @raw
  end

private

  def to_raw_format
    @raw = @record_hash
    convert_location
    sanitize_columns
    jsonify_form_values
  end

  def convert_location
    lat  = @raw.delete('latitude')
    long = @raw.delete('longitude')

    location = "#{lat},#{long}"
    @raw['location'] = location
  end

  def sanitize_columns
    @raw = RecordColumnSanitizer.new(@raw).sanitize
  end

  def jsonify_form_values
    @raw['form_values'] = @raw['form_values'].to_json
  end

  def form_columns
    unless @form_columns
      form_id = @fusion['form_id']
      @form_columns = Form.new(form_id).field_key_name_mappings
    end

    @form_columns
  end

  def form_values_hash
    unless @form_values_hash
      @form_values_hash = JSON.parse(@fusion['form_values'])
    end

    @form_values_hash
  end

  def  add_form_fields_as_keys
    return unless form_columns

    @fusion = mapped_form_values.merge(@fusion)
  end

  def mapped_form_values
    {}.tap do |h|
      form_values_hash.map do |column_id, value|
        column_name = form_columns[column_id]
        h[column_name] = value
      end
    end
  end
end

