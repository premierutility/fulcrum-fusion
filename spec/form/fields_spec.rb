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
            "data_name" => "name",
            "numeric" => false
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = text_field_data
        subject.fusion_columns_schema.
          should include({ name: 'name', type: 'string' })
      end
    end

    describe "with a numeric field" do
      let(:numeric_field_data) do
        [
          {
            "type" => "TextField",
            "key" => "7ef1",
            "label" => "Numba",
            "data_name" => "numba",
            "numeric" => true
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = numeric_field_data
        subject.fusion_columns_schema.
          should include({ name: 'numba', type: 'number' })
      end
    end

    describe "with a label" do
      let(:label_field_data) do
        [
          {
            "type" => "Label",
            "key" => "1efc",
            "label" => "Babel",
            "data_name" => "babel",
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
            "data_name" => "one_choice_yo",
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
          should include({ name: 'one_choice_yo', type: 'string' })
      end
    end

    describe "with a classification field" do
      let(:classification_set_field_data) do
        [
          {
            "type" => "ClassificationField",
            "key" => "71d6",
            "label" => "Classy Field",
            "data_name" => "classy_field",
            "allow_other" => true,
            "classification_set_id" => "469a98de-e3aa-405a-a0bb-5cf9f679c90b"
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = classification_set_field_data
        subject.fusion_columns_schema.
          should include({ name: 'classy_field', type: 'string' })
      end
    end

    describe "with a photo field" do
      let(:photo_field_data) do
        [
          {
            "type" => "PhotoField",
            "key" => "51f7",
            "label" => "Photoz",
            "data_name" => "photoz",
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = photo_field_data
        subject.fusion_columns_schema.
          should include({ name: 'photoz', type: 'string' })
      end
    end

    describe "with a datetime field" do
      let(:datetime_field_data) do
        [
          {
            "type" => "DateTimeField",
            "key" => "e219",
            "label" => "Da Date Field",
            "data_name" => "da_date_field",
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = datetime_field_data
        subject.fusion_columns_schema.
          should include({ name: 'da_date_field', type: 'string' })
      end
    end

    describe "with a address field" do
      let(:address_field_data) do
        [
          {
            "type" => "AddressField",
            "key" => "0ebd",
            "label" => "L'address",
            "data_name" => "laddress",
            "auto_populate" => true
          }
        ]
      end
      it "returns the right column schema" do
        @field_data = address_field_data
        subject.fusion_columns_schema.
          should include({ name: "laddress", type: 'string' })
      end
    end

    describe "with a signature field" do
      let(:signature_field_data) do
        [
          {
            "type" => "SignatureField",
            "key" => "486e",
            "label" => "Siggy",
            "data_name" => "siggy",
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = signature_field_data
        subject.fusion_columns_schema.
          should include({ name: "siggy", type: 'string' })
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
                "data_name" => "texty",
                "numeric" => false
              },
              {
                "type" => "TextField",
                "key" => "6519",
                "label" => "Nummy",
                "data_name" => "nummy",
                "numeric" => true
              }
            ]
          }
        ]
      end

      it "returns the right column schema" do
        @field_data = section_data
        subject.fusion_columns_schema.
          should include({ name: 'texty', type: 'string' }, { name: 'nummy', type: 'number'})
      end
    end
  end
end

