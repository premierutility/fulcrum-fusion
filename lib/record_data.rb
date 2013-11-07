require_relative 'form_fields'
require_relative 'form'
require_relative 'record_column_sanitizer'
require 'json'

class RecordData
  def initialize(event_data)
    @record = event_data
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
    @raw = @record
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

  def  add_form_fields_as_keys
    form_id = @fusion['form_id']
    form_columns = Form.new(form_id).field_key_name_mappings
    return unless form_columns

    raw_record_data = JSON.parse(@fusion['form_values'])
    mapped_form_values = map_record_data(form_columns, raw_record_data)
    @fusion = mapped_form_values.merge(@fusion)
  end

  def map_record_data(form_columns, raw_record_data)
    {}.tap do |h|
      raw_record_data.map do |column_id, value|
        column_name = form_columns[column_id]
        h[column_name] = value
      end
    end
  end
end

