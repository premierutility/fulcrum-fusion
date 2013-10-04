require 'sinatra'
require 'json'
require 'yaml'
require 'fusion_tables'

set :port, 3002 # Configure sinatra

get '/' do
  "Fulcrum Fusion is running"
end

post '/' do
  event_data = JSON.parse(request.body.first)

  process_event(event_data)
end

private
  def process_event(event_data)
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

  class FulcrumTable
    extend Forwardable
    def_delegator :table, :insert
    def_delegator :table, :update
    def_delegator :table, :delete
    def_delegator :table, :select

    attr_accessor :table

    def initialize
      # Configure settings
      config = YAML::load_file(File.join(File.dirname(__FILE__), 'credentials.yml'))

      # Configure fusion tables
      @ft = GData::Client::FusionTables.new
      @ft.clientlogin config["google_username"], config["google_password"]
      @ft.set_api_key config["google_api_key"]
    end

    def create_table(name)
      cols = [
        { name: "status",              type: "string"   },
        { name: "version",             type: "number"   },
        { name: "id",                  type: "string"   },
        { name: "form_id",             type: "string"   },
        { name: "project_id",          type: "string"   },
        { name: "created_at",          type: "string"   },
        { name: "updated_at",          type: "string"   },
        { name: "client_created_at",   type: "string"   },
        { name: "client_updated_at",   type: "string"   },
        { name: "created_by",          type: "string"   },
        { name: "created_by_id",       type: "string"   },
        { name: "updated_by",          type: "string"   },
        { name: "updated_by_id",       type: "string"   },
        { name: "assigned_to",         type: "string"   },
        { name: "assigned_to_id",      type: "string"   },
        { name: "form_values",         type: "string"   },
        { name: "location",            type: "location" },
        { name: "altitude",            type: "number"   },
        { name: "speed",               type: "number"   },
        { name: "course",              type: "string"   },
        { name: "horizontal_accuracy", type: "string"   },
        { name: "vertical_accuracy",   type: "string"   }
      ]

      self.table = @ft.create_table(name.to_s, cols)
    end

    def existing_table(fulcrum_id)
      tables = @ft.show_tables
      self.table = tables.select{|t| t.name.match(Regexp.new(fulcrum_id))}.first
    end

    def drop_table(fulcrum_id)
      @ft.drop(Regexp.new(fulcrum_id))
    end
  end

  def process_form(action, event_data)
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

