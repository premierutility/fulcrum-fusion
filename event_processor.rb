require './fulcrum_table'

class EventProcessor
  def process(event_data)
    event_name = event_data["type"]
    resource, action = *(event_name.split('.'))
    puts "Processing event: #{event_name}"
    case resource
    when 'form'
      process_form(action, event_data)
    when 'record'
      process_record(action, event_data)
    end
    # It seems like I need this puts here for the page to return properly.
    puts "Success!"
  end

  def process_form(action, event_data)
    id = event_data["data"]["id"].gsub("-", "")

    case action
      #TODO: On create, if this event has already come in once but failed for
      #some reason, we'll end up creating another one. We should make sure we
      #haven't already processed this event. Can we do that in this simple
      #application? Or maybe this one doesn't have much fault tolerance, which
      #is okay since it's super simple?
    when 'create'
      name       = event_data["data"]["name"].gsub(" ", "")
      table_name = "FulcrumApp_#{name}_WithId_#{id}"

      FulcrumTable.new.create_table(table_name)
    when 'update'
      # Not sure what we can update with this library.
    when 'delete'
      FulcrumTable.new.drop_table(id)
    end
  end

  def convert_form_data(form)
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

