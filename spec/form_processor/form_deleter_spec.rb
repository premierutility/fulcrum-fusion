require 'spec_helper'

RSpec.configure{|c| c.include Helpers::StubServicesHelper }

describe FormProcessor::FormDeleter do
  let(:processor) { described_class.new(table_name) }

  describe "#process" do
    include_context "stub fusion tables"
    include_context "stub objects"

    it "deletes a table that exists" do
      stub_fusion_show_tables([stub_table])
      stub_fusion_drop
      processor.process.should == Status::NO_CONTENT
    end

    it "accepts the event if the table doesn't exist" do
      stub_fusion_show_tables
      processor.process.should == Status::ACCEPTED
    end
  end
end

