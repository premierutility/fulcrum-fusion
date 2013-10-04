require './fulcrum_table'
require './form_processor'

class EventProcessor
  def process(event_data)
    event_name = event_data["type"]
    resource, action = *(event_name.split('.'))
    puts "Processing event: #{event_name}"
    case resource
    when 'form'
      FormProcessor.new.process(action, event_data)
    when 'record'
      process_record(action, event_data)
    end
    # It seems like I need this puts here for the page to return properly.
    puts "Success!"
  end

  def process_record(action, event_data)
    id = event_data["data"]["form_id"].gsub("-", "")
    f = FulcrumTable.new.existing_table(id)
    record_row = convert_record_data(event_data["data"])

    return unless f

    case action
    when 'create'
      f.insert([record_row])
    when 'update'
      row = f.select("ROWID", "WHERE id='#{record_row["id"]}'").first
      row_id = row ? row[:rowid] : nil
      if row_id
        f.update(row_id, record_row)
      end
    when 'delete'
      row = f.select("ROWID", "WHERE id='#{record_row["id"]}'").first
      row_id = row ? row[:rowid] : nil
      if row_id
        f.delete(row_id)
      end
    end
  rescue => e
    puts "ERROR: #{e.inspect}, #{e.backtrace}"
  end

  def convert_record_data(record)
    record["form_values"] = record["form_values"].to_json
    location = "#{record.delete('latitude')},#{record.delete('longitude')}"
    record['location'] = location
    record
  end
end

