require_relative 'field_base'

class NumericField < FieldBase
private
  def type
    DATA_TYPES[:number]
  end
end

