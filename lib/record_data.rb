require_relative 'form_fields'
require_relative 'record_column_sanitizer'

class RecordData
  def initialize(event_data)
    @record = event_data
  end

  def fusion_format
    unless @fusion
      @fusion = raw_format
      @fusion = convert_form_values(@fusion)
    end

    @fusion
  end

  def raw_format
    unless @raw
      @raw = @record
      @raw = convert_location(@raw)
      @raw = sanitize_columns(@raw)
    end

    @raw
  end

private
  def convert_location(record)
    lat  = record.delete('latitude')
    long = record.delete('longitude')

    location = "#{lat},#{long}"
    record['location'] = location
    record
  end

  def sanitize_columns(record)
    RecordColumnSanitizer.new(record).sanitize
  end

  def convert_form_values(record)
    form_id = record['form_id']
    form_columns = FormFields.get_form_columns form_id
    return unless form_columns

    raw_record_data = record['form_values']
    mapped_form_values = map_record_data(form_columns, raw_record_data)
    record = record.merge(mapped_form_values)

    record['form_values'] = record['form_values'].to_json
    record
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

