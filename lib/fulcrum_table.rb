require 'fusion_tables'
require 'forwardable'

class FulcrumTable
  extend Forwardable
  def_delegator :table, :insert
  def_delegator :table, :update
  def_delegator :table, :delete
  def_delegator :table, :select

  attr_accessor :table

  def self.system_columns
    COLS.each.map {|c| c[:name] }
  end

  def initialize(table_name)
    # Configure fusion tables
    @ft = GData::Client::FusionTables.new
    @ft.clientlogin ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASSWORD']
    @ft.set_api_key ENV['GOOGLE_API_KEY']

    @table_name = table_name.to_s
    retrieve_table
  end

  def create_table(user_columns)
    return if table_exists?

    all_columns = all_columns_with_users_first(user_columns)
    self.table = @ft.create_table(@table_name, all_columns)
  end

  def drop_table
    return unless table_exists?

    drop_count = @ft.drop(Regexp.new(@table_name))

    if drop_count == 1
      table
    else
      nil
    end
  end

  private
    def retrieve_table
      tables = @ft.show_tables
      self.table =
        tables.select{|t| t.name.match(Regexp.new(@table_name))}.first
    end

    def table_exists?
      !!table
    end

    def all_columns_with_users_first(user_columns)
      user_columns.concat(COLS)
    end

    COLS = [
      { name: "status",              type: "string"   },
      { name: "version",             type: "number"   },
      { name: "id",                  type: "string"   },
      { name: "form_id",             type: "string"   },
      { name: "form_version",        type: "number"   },
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

