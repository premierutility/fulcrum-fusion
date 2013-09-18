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
    Thread.new {
      event_name = event_data["event"]
      resource, action = *(event_name.split('.'))
      process_record(action, event_data) if resource == 'record'
    }.run
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
      ft = GData::Client::FusionTables.new
      ft.clientlogin config["google_username"], config["google_password"]
      ft.set_api_key config["google_api_key"]

      table_name = "Fulcrum_Fusion"
      cols = [
        { name: "status",              type: "string"   },
        { name: "version",             type: "number"   },
        { name: "id",                  type: "string"   },
        { name: "form_id",             type: "string"   },
        { name: "project_id",          type: "string"   },
        { name: "created_at",          type: "string"   }, #TODO: Change to datetime
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

      tables = ft.show_tables
      fusion_table = tables.select{|t| t.name == table_name}.first
      if !fusion_table
        self.table = ft.create_table(table_name, cols) if !fusion_table
      else
        self.table = fusion_table
      end
    end
  end

  def process_record(action, event_data)
    puts "Processing record #{action}"
    f = FulcrumTable.new
    record_row = convert_record_data(event_data["data"])

    case action
    when 'create'
      f.insert [record_row]
    when 'update'
      row_id = f.select("ROWID", "WHERE id='#{record_row["id"]}'").first[:rowid]
      f.update row_id, record_row
    when 'delete'
      row_id = f.select("ROWID", "WHERE id='#{record_row["id"]}'").first[:rowid]
      f.delete row_id
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
