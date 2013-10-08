class RecordData
  def initialize(event_data)
    @record = event_data
  end

  def converted
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
    @record['form_values'] = @record['form_values'].to_json
  end
end
