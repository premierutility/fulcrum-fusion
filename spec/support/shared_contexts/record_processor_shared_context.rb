module SharedContexts
  module RecordProcessorSharedContext
    shared_context "record event data" do
      RSpec.configure{|c| c.include SharedContexts::EventDataSharedContext}
      RSpec.configure{|c| c.include SharedContexts::StubServicesSharedContext}
      RSpec.configure{|c| c.include Helpers::StubServicesHelper }

      include_context "stub fusion tables"
      include_context "stub fulcrum"
      include_context "event data"
      include_context "stub objects"

      let(:record) { RecordData.new(record_data) }
      let(:processor) { described_class.new(@table, @record) }
    end

    shared_context "new record" do
      before :each do
        GData::Client::FusionTables.any_instance.stub(:select).
          and_return([])
        @table = GData::Client::FusionTables.new
        @record = record
      end
    end

    shared_context "existing record" do
      let(:rowid) { 'fakeid' }
      let(:rowid_hash) { { rowid: rowid } }

      before :each do
        @table = stub_table
        @record = record
      end
    end
  end
end

