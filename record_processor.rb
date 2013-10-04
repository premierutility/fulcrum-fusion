class RecordProcessor
  def process(action, event_data)
    id = event_data["data"]["form_id"].gsub("-", "")
    f = FulcrumTable.new.existing_table(id)
    record_row = convert_record_data(event_data["data"])

    # The record is for a table that doesn't exist, so don't process it.
    return 202 unless f

    case action
    when 'create'
      f.insert([record_row])
      201
    when 'update'
      row = f.select("ROWID", "WHERE id='#{record_row["id"]}'").first
      row_id = row ? row[:rowid] : nil
      if row_id
        f.update(row_id, record_row)
      end
      200
    when 'delete'
      row = f.select("ROWID", "WHERE id='#{record_row["id"]}'").first
      row_id = row ? row[:rowid] : nil
      if row_id
        f.delete(row_id)
      end
      204
    end
  rescue => e
    puts "ERROR: #{e.inspect}, #{e.backtrace}"
  end

private
  def convert_record_data(record)
    record["form_values"] = record["form_values"].to_json
    location = "#{record.delete('latitude')},#{record.delete('longitude')}"
    record['location'] = location
    record
  end
end

