class ColumnNames
  def self.from_form(columns_data)
    columns_data.
      map{|e| [e["key"], e["label"]] }.
      sort{|a,b| a[0] <=> b[0]}.
      map{|e| {name: e[1], type: "string"} }
  end
end
