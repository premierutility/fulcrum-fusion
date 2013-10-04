class FormProcessor
  def process(action, event_data)
    id = event_data["data"]["id"].gsub("-", "")

    case action
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

  private
end
