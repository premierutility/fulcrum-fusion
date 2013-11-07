require_relative 'field_base'

class TextField < FieldBase
private
  def type
    DATA_TYPES[:string]
  end
end

