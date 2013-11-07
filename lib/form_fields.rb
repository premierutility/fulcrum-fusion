require_relative 'form_fields/fusion_columns_schema'

class FormFields
  def initialize(form_fields)
    @form_fields = form_fields
  end

  def fusion_columns_schema
    FusionColumnsSchema.new(@form_fields).schema
  end
end

