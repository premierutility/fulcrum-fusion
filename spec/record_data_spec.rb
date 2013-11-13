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
    describe "with a text field" do
      let(:expected_fusion_format_with_text_field) do
        { 'Name' => 'Fake Record' }.
          merge(expected_raw_format)
      end

      it "converts the data properly" do
        Form.any_instance.stub(:field_key_name_mappings).
          and_return({'94f8' => 'Name'})
        actual_fusion_format = RecordData.new(record_data).fusion_format
        actual_fusion_format.should == expected_fusion_format_with_text_field
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
