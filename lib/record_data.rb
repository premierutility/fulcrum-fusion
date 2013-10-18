require_relative 'column_names'

class RecordData
  def initialize(event_data)
    @record = event_data

  end

  def to_fusion_format
    convert_location
    convert_form_values
    @record
  end

private
  def convert_location
    lat  = @record.delete('latitude')
    long = @record.delete('longitude')

    location = "#{lat},#{long}"
    @record['location'] = location
  end

  def convert_form_values
    form_id = @record['form_id']
    form_columns = ColumnNames.get_form_columns form_id
    return unless form_columns

    raw_record_data = @record['form_values']
    map_record_data(form_columns, raw_record_data)

    @record['form_values'] = @record['form_values'].to_json
  end

  def map_record_data(form_columns, raw_record_data)
    raw_record_data.map do |column_id, value|
      column_name = form_columns[column_id]
      @record[column_name] = value
    end
  end
end

