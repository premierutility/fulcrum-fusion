require_relative 'system_columns'

class RecordColumnSanitizer
  def initialize(attrs)
    @attrs = attrs
  end

  def sanitize
    @attrs.slice(*SystemColumns.names)
  end
end

