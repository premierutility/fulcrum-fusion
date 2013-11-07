require_relative 'system_columns'
require 'active_support/core_ext'

class RecordColumnSanitizer
  def initialize(attrs)
    @attrs = attrs
  end

  def sanitize
    @attrs.slice(*SystemColumns.names)
  end
end

