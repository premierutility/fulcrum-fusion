require 'spec_helper'

describe Form::Fields do

  subject { described_class.new(@field_data) }

  describe "#fusion_columns_schema" do
    describe "with a text field" do
      let(:text_field_data) do
        [
          {
            "type" => "TextField",
            "key" => "94f8",
            "label" => "Name",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "name",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil,
            "numeric" => false
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = text_field_data
        subject.fusion_columns_schema.
          should include({ name: 'Name', type: 'string' })
      end
    end

    describe "with a numeric field" do
      let(:numeric_field_data) do
        [
          {
            "type" => "TextField",
            "key" => "7ef1",
            "label" => "Numba",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "name",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil,
            "numeric" => true
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = numeric_field_data
        subject.fusion_columns_schema.
          should include({ name: 'Numba', type: 'number' })
      end
    end

    describe "with a label" do
      let(:label_field_data) do
        [
          {
            "type" => "Label",
            "key" => "1efc",
            "label" => "Babel",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "name",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil,
            "numeric" => false
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = label_field_data
        subject.fusion_columns_schema.should == []
      end
    end

    describe "with a choice field" do
      let(:choice_field_data) do
        [
          {
            "type" => "ChoiceField",
            "key" => "aed4",
            "label" => "One Choice yo",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "one_choice_yo",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil,
            "multiple" => false,
            "allow_other" => true,
            "choices" =>
              [
                {
                  "label" => "a",
                  "value" => "a"
                },
                {
                  "label" => "b",
                  "value" => "b"
                },
                {
                  "label" => "c",
                  "value" => "c"
                },
                {
                  "label" => "blah",
                  "value" => "blah"
                },
                {
                  "label" => "hi",
                  "value" => "hi"
                },
                {
                  "label" => "lol",
                  "value" => "lol"
                }
              ]
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = choice_field_data
        subject.fusion_columns_schema.
          should include({ name: 'One Choice yo', type: 'string' })
      end
    end

    describe "with a classification field" do
      let(:classification_set_field_data) do
        [
          {
            "type" => "ClassificationField",
            "key" => "71d6",
            "label" => "Classy Field",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "classy_field",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil,
            "allow_other" => true,
            "classification_set_id" => "469a98de-e3aa-405a-a0bb-5cf9f679c90b"
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = classification_set_field_data
        subject.fusion_columns_schema.
          should include({ name: 'Classy Field', type: 'string' })
      end
    end

    describe "with a photo field" do
      let(:photo_field_data) do
        [
          {
            "type" => "PhotoField",
            "key" => "51f7",
            "label" => "Photoz",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "photoz",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = photo_field_data
        subject.fusion_columns_schema.
          should include({ name: 'Photoz', type: 'string' })
      end
    end

    describe "with a datetime field" do
      let(:datetime_field_data) do
        [
          {
            "type" => "DateTimeField",
            "key" => "e219",
            "label" => "Da Date Field",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "da_date_field",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = datetime_field_data
        subject.fusion_columns_schema.
          should include({ name: 'Da Date Field', type: 'string' })
      end
    end

    describe "with a address field" do
      let(:address_field_data) do
        [
          {
            "type" => "AddressField",
            "key" => "0ebd",
            "label" => "L'address",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "laddress",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil,
            "auto_populate" => true
          }
        ]
      end
      it "returns the right column schema" do
        @field_data = address_field_data
        subject.fusion_columns_schema.
          should include({ name: "L'address", type: 'string' })
      end
    end

    describe "with a signature field" do
      let(:signature_field_data) do
        [
          {
            "type" => "SignatureField",
            "key" => "486e",
            "label" => "Siggy",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "siggy",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil,
            "agreement_text" => ""
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = signature_field_data
        subject.fusion_columns_schema.
          should include({ name: "Siggy", type: 'string' })
      end
    end

    describe "with a section" do
      let(:section_data) do
        [
          {
            "type" => "Section",
            "key" => "344a",
            "label" => "A Special Section",
            "description" => nil,
            "required" => false,
            "disabled" => false,
            "hidden" => false,
            "data_name" => "a_special_section",
            "default_value" => nil,
            "visible_conditions_type" => nil,
            "visible_conditions" => nil,
            "required_conditions_type" => nil,
            "required_conditions" => nil,
            "display" => "inline",
            "elements" => [
              {
                "type" => "TextField",
                "key" => "4c79",
                "label" => "Texty",
                "description" => nil,
                "required" => false,
                "disabled" => false,
                "hidden" => false,
                "data_name" => "texty",
                "default_value" => nil,
                "visible_conditions_type" => nil,
                "visible_conditions" => nil,
                "required_conditions_type" => nil,
                "required_conditions" => nil,
                "numeric" => false
              },
              {
                "type" => "TextField",
                "key" => "6519",
                "label" => "Nummy",
                "description" => nil,
                "required" => false,
                "disabled" => false,
                "hidden" => false,
                "data_name" => "nummy",
                "default_value" => nil,
                "visible_conditions_type" => nil,
                "visible_conditions" => nil,
                "required_conditions_type" => nil,
                "required_conditions" => nil,
                "numeric" => true
              }
            ]
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = section_data
        subject.fusion_columns_schema.
          should include({ name: 'A Special Section - Texty', type: 'string' }, { name: 'A Special Section - Nummy', type: 'number'})
      end
    end
  end
end

