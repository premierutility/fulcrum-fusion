require 'spec_helper'
require_relative 'support/shared_contexts/event_data_shared_context'

RSpec.configure{|c| c.include SharedContexts::EventDataSharedContext }
RSpec.configure{|c| c.include SharedContexts::StubServicesSharedContext }

describe RecordProcessor do
  describe "#process" do
    include_context "event data"
    include_context "stub fusion tables"

    let(:processor) { RecordProcessor.new(@action.to_s, record_event_data) }

    before :each do
      FormUtils.stub(:id).and_return('fakeid')
    end

    describe "with a table that exists" do
      before :each do
        FulcrumTable.any_instance.stub(:table).and_return(Object.new)
      end

      it "processes record create events" do
        @action = :create
        RecordProcessor::RecordCreator.any_instance.
          should_receive(:process).
          and_return(Status::CREATED)
        processor.process.should == Status::CREATED
      end

      it "processes record update events" do
        @action = :update
        RecordProcessor::RecordUpdater.any_instance.
          should_receive(:process).
          and_return(Status::NO_CONTENT)
        processor.process.should == Status::NO_CONTENT
      end

      it "processes record delete events" do
        @action = :delete
        RecordProcessor::RecordDeleter.any_instance.
          should_receive(:process).
          and_return(Status::NO_CONTENT)
        processor.process.should == Status::NO_CONTENT
      end

      it "ignores bogus record events" do
        @action = :bogus
        processor.process.should == Status::ACCEPTED
      end
    end

    describe "with a non-existant table" do
      before :each do
        FulcrumTable.any_instance.stub(:table)
      end

      it "accepts record create events" do
        @action = :create
        RecordProcessor::RecordCreator.any_instance.
          should_not_receive(:process)
        processor.process.should == Status::ACCEPTED
      end

      it "accepts record update events" do
        @action = :update
        RecordProcessor::RecordUpdater.any_instance.
          should_not_receive(:process)
        processor.process.should == Status::ACCEPTED
      end

      it "accepts record delete events" do
        @action = :delete
        RecordProcessor::RecordDeleter.any_instance.
          should_not_receive(:process)
        processor.process.should == Status::ACCEPTED
      end

      it "accepts bogus record events" do
        @action = :bogus
        processor.process.should == Status::ACCEPTED
      end
    end
  end
end
