require 'spec_helper'

RSpec.configure{|c| c.include SharedContexts::RecordProcessorSharedContext}

describe RecordProcessor::RecordCreator do
  describe "#process" do
    include_context "record event data"

    describe "with a brand new record" do
      include_context "new record"

      describe "with no errors" do
        it "creates the record" do
          GData::Client::FusionTables.any_instance.stub(:insert)
          processor.process.should == Status::CREATED
        end
      end

      describe "with an extra column" do
        let(:bad_record) do
          RecordData.new(bad_record_data)
        end

        before :each do
          @record = bad_record
        end

        describe "where it can't insert the record at all" do
          it "returns an internal error" do
            GData::Client::FusionTables.any_instance.stub(:insert).
              and_raise(ArgumentError, "The column doesn't exist")
            processor.process.should == Status::INTERNAL_ERROR
          end
        end

        describe "where it can't insert the fusion format" do
          it "inserts the raw format" do
            Fulcrum::Form.stub(:find).
              and_return({'form'=>{'elements'=>[{'key'=>'94f8','label'=>'name'},{'key'=>'876d','label'=>'fake'}]}})
            @times_called = 0
            GData::Client::FusionTables.any_instance.stub(:insert) do
              if @times_called == 0
                @times_called += 1
                raise ArgumentError, "The column doesn't exist"
              end
            end

            @table.should_receive(:insert).once.
              with([record_fusion_data]).
              and_raise(ArgumentError,"The column doesn't exist")
            @table.should_receive(:insert).once.
              with([record_raw_data])
            processor.process.should == Status::CREATED
          end
        end
      end

      describe "with some other error" do
        it "returns an internal error" do
          GData::Client::FusionTables.any_instance.stub(:insert).
            and_raise(TypeError)
          processor.process.should == Status::INTERNAL_ERROR
        end
      end
    end

    describe "with an existing record" do
      include_context "existing record"

      it "accepts the event" do
        processor.process.should == Status::ACCEPTED
      end
    end
  end
end

