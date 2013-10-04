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
      self.table = @ft.create_table(name.to_s, COLS)
    end

    def existing_table(fulcrum_id)
      tables = @ft.show_tables
      self.table = tables.select{|t| t.name.match(Regexp.new(fulcrum_id))}.first
    end

    def drop_table(fulcrum_id)
      @ft.drop(Regexp.new(fulcrum_id))
    end

    private
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

