require 'spec_helper'
require_relative 'support/shared_contexts/event_data_shared_context'

RSpec.configure{|c| c.include SharedContexts::EventDataSharedContext }

describe RecordData do
  include_context "event data"

  let(:expected_raw_format) do
    record_data.dup.tap do |h|
      # Lat,long is turned into a location
      h.delete('latitude')
      h.delete('longitude')
      h['location'] = '38.8968321491252,-104.831140637398'

      # keys are sanitized
      h.delete('extra_hash_key')

      # Form values is turned into JSON
      h['form_values'] = '{"94f8":"Fake Record"}'
    end
  end

  describe "#fusion_format" do
    describe "with an address field" do
      let(:expected_fusion_format) do
        { 'Addy' => "1600 penn ave ste 100, capitol, Wash DC 11111" }.
          merge(expected_raw_format).
          merge({'form_values' => "{\"94f8\":{\"sub_thoroughfare\":\"1600\",\"thoroughfare\":\"penn ave\",\"suite\":\"ste 100\",\"locality\":\"capitol\",\"admin_area\":\"Wash DC\",\"postal_code\":\"11111\"}}"})
      end

      let(:numeric_record) do
        record_data.merge(
          {
            'form_values' =>
              {
                '94f8' =>
                  {
                    "sub_thoroughfare" => "1600",
                    "thoroughfare" => "penn ave",
                    "suite" => "ste 100",
                    "locality" => "capitol",
                    "admin_area" => "Wash DC",
                    "postal_code" => "11111"
                  }
              }
          }
        )
      end

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "AddressField",
              "key" => "94f8",
              "label" => "Addy",
            }
          )
        actual_fusion_format = RecordData.new(numeric_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a choice field" do
      let(:expected_fusion_format) do
        { 'Singly' => "two, three" }.
          merge(expected_raw_format).
          merge({'form_values' => "{\"94f8\":{\"choice_values\":[\"two\",\"three\"],\"other_values\":[]}}"})
      end

      let(:numeric_record) do
        record_data.merge(
          {
            'form_values' =>
              {
                '94f8' =>
                  {
                    "choice_values" => [ "two", "three" ],
                    "other_values" => []
                  }
              }
          }
        )
      end

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "ChoiceField",
              "key" => "38b3",
              "label" => "Singly",
              "multiple" => false,
              "allow_other" => true,
              "choices" => [
                {
                  "label" => "one",
                  "value" => "one"
                },
                {
                  "label" => "two",
                  "value" => "two"
                },
                {
                  "label" => "three",
                  "value" => "three"
                },
                {
                  "label" => "four",
                  "value" => "four"
                }
              ]
            }
          )
        actual_fusion_format = RecordData.new(numeric_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a classification field"
    describe "with a datetime field"
    describe "with a label"
    describe "with a photo field"
    describe "with a section"
    describe "with a signature field"

    describe "with a text field" do
      let(:expected_fusion_format) do
        { 'Name' => 'Fake Record' }.
          merge(expected_raw_format)
      end

      let(:text_record) { record_data }

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "TextField",
              "key" => "94f8",
              "label" => "Name",
              "numeric" => false
            }
          )
        actual_fusion_format = RecordData.new(text_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a numeric field" do
      let(:expected_fusion_format) do
        { 'Number' => "100" }.
          merge(expected_raw_format).
          merge({'form_values' => "{\"94f8\":\"100\"}"})
      end

      let(:numeric_record) do
        record_data.merge( {'form_values' => { '94f8' => '100' } } )
      end

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "TextField",
              "key" => "94f8",
              "label" => "Number",
              "numeric" => true
            }
          )
        actual_fusion_format = RecordData.new(numeric_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end
  end

  describe "#raw_format" do
    it "converts the data properly" do
      actual_raw_format = RecordData.new(record_data).raw_format
      actual_raw_format.should == expected_raw_format
    end
  end
end
