require './record_creator'
require './record_updater'
require './record_deleter'

class RecordProcessor
  def initialize(action_name, event_data)
    @action_name = action_name
    @event_data  = event_data
    @record_row = convert_record_data(@event_data["data"])

    id = @event_data["data"]["form_id"].gsub("-", "")
    @table = FulcrumTable.new.existing_table(id)
  end

  def process
    return 202 unless action

    action.process
  end

private
  def action
    # The record is for a table that doesn't exist, so don't process it.
    return nil unless @table

    return @action if @action

    case @action_name
    when 'create'
      klass = RecordCreator

    when 'update'
      klass = RecordUpdater

    when 'delete'
      klass = RecordDeleter

    else
      return nil
    end

    @action = klass.new(@table, @record_row)
  end

  def convert_record_data(record)
    record["form_values"] = record["form_values"].to_json
    location = "#{record.delete('latitude')},#{record.delete('longitude')}"
    record['location'] = location
    record
  end
end

