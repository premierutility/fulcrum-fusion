require 'yaml'

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
    return unless table_doesnt_exist(name)
    self.table = @ft.create_table(name.to_s, COLS)
  end

  def existing_table(fulcrum_id)
    self.table = retrieve_table(fulcrum_id)
  end

  def drop_table(fulcrum_id)
    table = retrieve_table(fulcrum_id)
    return unless table

    drop_count = @ft.drop(Regexp.new(fulcrum_id))

    if drop_count == 1
      table
    else
      nil
    end
  end

  private
    def table_doesnt_exist(text)
      retrieve_table(text) == nil
    end

    def retrieve_table(text)
      tables = @ft.show_tables
      tables.select{|t| t.name.match(Regexp.new(text))}.first
    end

    COLS = [
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
end

