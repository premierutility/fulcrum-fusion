require 'spec_helper'

describe RecordProcessor::RecordUpdater do
  describe "#process" do
    include_context "record event data"

    describe "for an existing row" do
      include_context "existing record"

      before :each do
        @table = GData::Client::FusionTables.new
        GData::Client::FusionTables.any_instance.stub(:select).
          and_return([rowid_hash])
      end

      describe "with no errors" do
        it "updates the record" do
          GData::Client::FusionTables.any_instance.stub(:update)
          processor.process.should == Status::NO_CONTENT
        end
      end

      describe "with an extra column" do
        describe "where it can't update the record at all" do
          it "returns an internal error" do
            GData::Client::FusionTables.any_instance.stub(:update).
              and_raise(ArgumentError.new("The column doesn't exist"))
            processor.process.should == Status::INTERNAL_ERROR
          end
        end

        describe "where it can't update the fusion format" do
          it "updates the raw format" do
            @times_called = 0
            GData::Client::FusionTables.any_instance.stub(:update) do
              if @times_called == 0
                @times_called += 1
                raise ArgumentError, "The column doesn't exist"
              end
            end

            processor.process.should == Status::NO_CONTENT
          end
        end
      end

      describe "with some other error" do
        it "returns an internal error" do
          GData::Client::FusionTables.any_instance.stub(:update).
            and_raise(StandardError)
          processor.process.should == Status::INTERNAL_ERROR
        end
      end
    end

    describe "for a non-existant row" do
      include_context "new record"

      before :each do
        GData::Client::FusionTables.any_instance.stub(:select).
          and_return([])
      end

      it "accepts the event" do
        processor.process.should == Status::ACCEPTED
      end
    end
  end
end

