require_relative 'form'
require_relative 'record_column_sanitizer'
require_relative 'record_data/extractor'

class RecordData
  def initialize(record_hash)
    @record_hash = record_hash
  end

  def fusion_format
    unless @fusion
      @fusion = raw_format
      add_record_values_to_top_level
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
    parse_datetimes
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

  def parse_datetimes
    @raw = @raw.each do |key, value|
      if datetime_field?(key)
        @raw[key] = DateTime.parse value
      end
    end
  end

  def datetime_field?(field_key)
    field_key.match(/_at$/)
  end

  def jsonify_form_values
    @raw['form_values'] = @raw['form_values'].to_json
  end

  def add_record_values_to_top_level
    record_values = RecordData::Extractor.new(@fusion).extract
    @fusion = record_values.merge(@fusion)
  end
end

