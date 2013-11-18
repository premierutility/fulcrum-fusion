class SystemColumns
  def self.data
    COLS
  end

  def self.names
    COLS.each.map {|c| c[:name] }
  end

  private
    COLS = [
      { name: "status",              type: "string"   },
      { name: "version",             type: "number"   },
      { name: "id",                  type: "string"   },
      { name: "form_id",             type: "string"   },
      { name: "form_version",        type: "number"   },
      { name: "project_id",          type: "string"   },
      { name: "created_at",          type: "datetime" },
      { name: "updated_at",          type: "datetime" },
      { name: "client_created_at",   type: "datetime" },
      { name: "client_updated_at",   type: "datetime" },
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
