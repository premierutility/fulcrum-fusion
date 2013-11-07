require 'spec_helper'
require_relative 'support/shared_contexts/event_data_shared_context'

RSpec.configure{|c| c.include SharedContexts::EventDataSharedContext }

describe RecordData do
  include_context "event data"

  let(:expected_raw_format) do
    {
      'status' => nil,
      'version' => 1,
      'id' => '7553fd44-78bb',
      'form_id' => '295eda4a-7795',
      'project_id' => nil,
      'created_at' => '2013-09-21T19:20:16Z',
      'updated_at' => '2013-09-21T19:20:16Z',
      'client_created_at' => '2013-09-21T19:20:16Z',
      'client_updated_at' => '2013-09-21T19:20:16Z',
      'created_by' => 'dev Test',
      'created_by_id' => '960247b1',
      'updated_by' => 'dev Test',
      'updated_by_id' => '960247b1',
      'assigned_to' => nil,
      'assigned_to_id' => nil,
      'form_values' => '{"94f8":"Fake Record"}',
      'location' => '38.8968321491252,-104.831140637398',
      'altitude' => nil,
      'speed' => nil,
      'course' => nil,
      'horizontal_accuracy' => nil,
      'vertical_accuracy' => nil
    }
  end

  let(:expected_fusion_format) do
    {
      'Name' => 'Fake Record',
      'status' => nil,
      'version' => 1,
      'id' => '7553fd44-78bb',
      'form_id' => '295eda4a-7795',
      'project_id' => nil,
      'created_at' => '2013-09-21T19:20:16Z',
      'updated_at' => '2013-09-21T19:20:16Z',
      'client_created_at' => '2013-09-21T19:20:16Z',
      'client_updated_at' => '2013-09-21T19:20:16Z',
      'created_by' => 'dev Test',
      'created_by_id' => '960247b1',
      'updated_by' => 'dev Test',
      'updated_by_id' => '960247b1',
      'assigned_to' => nil,
      'assigned_to_id' => nil,
      'form_values' => '{"94f8":"Fake Record"}',
      'location' => '38.8968321491252,-104.831140637398',
      'altitude' => nil,
      'speed' => nil,
      'course' => nil,
      'horizontal_accuracy' => nil,
      'vertical_accuracy' => nil
    }
  end

  describe "#fusion_format" do
    it "converts the data properly" do
      Form.any_instance.stub(:field_key_name_mappings).
        and_return({'94f8' => 'Name'})
      actual_fusion_format = RecordData.new(record_data).fusion_format
      actual_fusion_format.should == expected_fusion_format
    end
  end

  describe "#raw_format" do
    it "converts the data properly" do
      actual_raw_format = RecordData.new(record_data).raw_format
      actual_raw_format.should == expected_raw_format
    end
  end
end
