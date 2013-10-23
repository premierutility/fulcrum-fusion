require_relative 'fulcrum_table'

class RecordColumnSanitizer
  def initialize(attrs)
    @attrs = attrs
  end

  def sanitize
    @attrs.slice(*FulcrumTable.system_columns)
  end
end

