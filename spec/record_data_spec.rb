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
        { 'addy' => "1600 penn ave ste 100, capitol, Wash DC 11111" }.
          merge(expected_raw_format).
          merge({'form_values' => "{\"94f8\":{\"sub_thoroughfare\":\"1600\",\"thoroughfare\":\"penn ave\",\"suite\":\"ste 100\",\"locality\":\"capitol\",\"admin_area\":\"Wash DC\",\"postal_code\":\"11111\"}}"})
      end

      let(:address_record) do
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
              "data_name" => "addy",
            }
          )

        actual_fusion_format = RecordData.new(address_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a choice field" do
      let(:expected_fusion_format) do
        { 'singly' => "two, three" }.
          merge(record_raw_data).
          merge({'form_values' => "{\"94f8\":{\"choice_values\":[\"two\",\"three\"],\"other_values\":[]}}"})
      end

      let(:choice_record) do
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
              "key" => "94f8",
              "data_name" => "singly",
            }
          )

        actual_fusion_format = RecordData.new(choice_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a classification field" do
      let(:expected_fusion_format) do
        { 'classy' => "christian, denomination=maronite" }.
          merge(record_raw_data).
          merge({'form_values' => "{\"94f8\":{\"choice_values\":[\"christian\",\"denomination=maronite\"],\"other_values\":[]}}"})
      end

      let(:classification_record) do
        record_data.merge(
          {
            'form_values' =>
              {
                '94f8' =>
                  {
                    "choice_values" =>
                      [ "christian", "denomination=maronite" ],
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
              "type" => "ClassificationField",
              "key" => "94f8",
              "data_name" => "classy",
            }
          )

        actual_fusion_format = RecordData.new(classification_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a datetime field" do
      let(:expected_fusion_format) do
        { 'datey' => DateTime.parse("2013-12-25") }.
          merge(record_raw_data).
          merge({'form_values' => "{\"94f8\":\"2013-12-25\"}"})
      end

      let(:datetime_record) do
        record_data.merge(
          {
            'form_values' =>
              {
                '94f8' => "2013-12-25"
              }
          }
        )
      end

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "DateTimeField",
              "key" => "94f8",
              "data_name" => "datey",
            }
          )

        actual_fusion_format = RecordData.new(datetime_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a photo field" do
      let(:expected_fusion_format) do
        { 'photoy' => "http://localhost:3000/api/v2/photos/18ae3963-cf55-bfc4-0ca1-2890f8de88d6.jpg http://localhost:3000/api/v2/photos/c91f8175-6245-3166-a024-cc5a1e4f0f2a.jpg" }.
          merge(record_raw_data).
          merge({'form_values' => "{\"94f8\":[{\"photo_id\":\"18ae3963-cf55-bfc4-0ca1-2890f8de88d6\",\"caption\":\"First caption\",\"url\":\"http://localhost:3000/api/v2/photos/18ae3963-cf55-bfc4-0ca1-2890f8de88d6.jpg\",\"thumbnail\":\"http://localhost:3000/api/v2/photos/18ae3963-cf55-bfc4-0ca1-2890f8de88d6/thumbnail.jpg\",\"large\":\"http://localhost:3000/api/v2/photos/18ae3963-cf55-bfc4-0ca1-2890f8de88d6/large.jpg\"},{\"photo_id\":\"c91f8175-6245-3166-a024-cc5a1e4f0f2a\",\"caption\":\"Second caption\",\"url\":\"http://localhost:3000/api/v2/photos/c91f8175-6245-3166-a024-cc5a1e4f0f2a.jpg\",\"thumbnail\":\"http://localhost:3000/api/v2/photos/c91f8175-6245-3166-a024-cc5a1e4f0f2a/thumbnail.jpg\",\"large\":\"http://localhost:3000/api/v2/photos/c91f8175-6245-3166-a024-cc5a1e4f0f2a/large.jpg\"}]}"})
      end

      let(:photo_record) do
        record_data.merge(
          {
            'form_values' =>
              {
                '94f8' =>
                  [
                    {
                      "photo_id" => "18ae3963-cf55-bfc4-0ca1-2890f8de88d6",
                      "caption" => "First caption",
                      "url" => "http://localhost:3000/api/v2/photos/18ae3963-cf55-bfc4-0ca1-2890f8de88d6.jpg",
                      "thumbnail" => "http://localhost:3000/api/v2/photos/18ae3963-cf55-bfc4-0ca1-2890f8de88d6/thumbnail.jpg",
                      "large" => "http://localhost:3000/api/v2/photos/18ae3963-cf55-bfc4-0ca1-2890f8de88d6/large.jpg"
                    },
                    {
                      "photo_id" => "c91f8175-6245-3166-a024-cc5a1e4f0f2a",
                      "caption" => "Second caption",
                      "url" => "http://localhost:3000/api/v2/photos/c91f8175-6245-3166-a024-cc5a1e4f0f2a.jpg",
                      "thumbnail" => "http://localhost:3000/api/v2/photos/c91f8175-6245-3166-a024-cc5a1e4f0f2a/thumbnail.jpg",
                      "large" => "http://localhost:3000/api/v2/photos/c91f8175-6245-3166-a024-cc5a1e4f0f2a/large.jpg"
                    }
                  ]
              }
          }
        )
      end

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "PhotoField",
              "key" => "94f8",
              "data_name" => "photoy",
            }
          )

        actual_fusion_format = RecordData.new(photo_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a signature field" do
      let(:expected_fusion_format) do
        { 'siggy' => "http://localhost:3000/api/v2/signatures/f98e60f0-7a63-0ef3-13ae-ccf28e488ec3.png" }.
          merge(record_raw_data).
          merge({'form_values' => "{\"94f8\":{\"signature_id\":\"f98e60f0-7a63-0ef3-13ae-ccf28e488ec3\",\"url\":\"http://localhost:3000/api/v2/signatures/f98e60f0-7a63-0ef3-13ae-ccf28e488ec3.png\",\"thumbnail\":\"http://localhost:3000/api/v2/signatures/f98e60f0-7a63-0ef3-13ae-ccf28e488ec3/thumbnail.png\",\"large\":\"http://localhost:3000/api/v2/signatures/f98e60f0-7a63-0ef3-13ae-ccf28e488ec3/large.png\"}}"})
      end

      let(:signature_record) do
        record_data.merge(
          {
            'form_values' =>
              {
                '94f8' =>
                  {
                    "signature_id" => "f98e60f0-7a63-0ef3-13ae-ccf28e488ec3",
                    "url" => "http://localhost:3000/api/v2/signatures/f98e60f0-7a63-0ef3-13ae-ccf28e488ec3.png",
                    "thumbnail" => "http://localhost:3000/api/v2/signatures/f98e60f0-7a63-0ef3-13ae-ccf28e488ec3/thumbnail.png",
                    "large" => "http://localhost:3000/api/v2/signatures/f98e60f0-7a63-0ef3-13ae-ccf28e488ec3/large.png"
                  }
              }
          }
        )
      end

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "SignatureField",
              "key" => "94f8",
              "data_name" => "siggy",
            }
          )

        actual_fusion_format = RecordData.new(signature_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a text field" do
      let(:expected_fusion_format) do
        { 'name' => 'Fake Record' }.
          merge(record_raw_data)
      end

      let(:text_record) { record_data }

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "TextField",
              "key" => "94f8",
              "data_name" => "name",
              "numeric" => false
            }
          )

        actual_fusion_format = RecordData.new(text_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a numeric field" do
      let(:expected_fusion_format) do
        { 'number' => "100" }.
          merge(record_raw_data).
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
              "data_name" => "number",
              "numeric" => true
            }
          )

        actual_fusion_format = RecordData.new(numeric_record).fusion_format
        actual_fusion_format.should == expected_fusion_format
      end
    end

    describe "with a field of unknown type" do
      let(:expected_fusion_format) do
        { 'whatever_field' => "{\"dummy\":\"content\"}" }.
          merge(record_raw_data).
          merge({'form_values' => "{\"94f8\":{\"dummy\":\"content\"}}"})
      end

      let(:unknown_record) do
        record_data.
          merge( {'form_values' => { '94f8' => { 'dummy' => 'content' } } } )
      end

      it "converts the data properly" do
        Form.any_instance.stub(:find_field_by_key).with('94f8').
          and_return(
            {
              "type" => "UnknownField",
              "key" => "94f8",
              "data_name" => "whatever_field"
            }
          )

        actual_fusion_format = RecordData.new(unknown_record).fusion_format
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

