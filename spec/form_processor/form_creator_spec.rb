require 'spec_helper'

RSpec.configure{|c| c.include SharedContexts::EventDataSharedContext }
RSpec.configure{|c| c.include SharedContexts::StubServicesSharedContext }

describe FormProcessor::FormCreator do
  include_context "event data"

  let(:processor) { described_class.new("fakeid", form_event_data) }

  describe "#process" do
    include_context "stub fusion tables"
    include_context "stub fulcrum"

    it "creates a table that doesn't exist" do
      stub_fusion_create_table
      processor.process.should == Status::CREATED
    end

    it "accepts the event if a table exists" do
      stub_fusion_create_table(nil)
      processor.process.should == Status::ACCEPTED
    end
  end
end

