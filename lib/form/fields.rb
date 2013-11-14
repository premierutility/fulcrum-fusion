require_relative 'fields/fusion_columns_schema'

class Form
  class Fields
    def initialize(form_fields)
      @form_fields = form_fields
    end

    def fusion_columns_schema
      Form::Fields::FusionColumnsSchema.new(@form_fields).schema
    end
  end
end

