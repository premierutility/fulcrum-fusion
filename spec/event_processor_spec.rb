require 'spec_helper'

describe EventProcessor do
  let(:test_event)        { {'type' => 'test.test'} }
  let(:form_create_event) { {'type' => 'form.create'} }

  it "has a NUMBER_OF_TIMES_TO_RETRY" do
    described_class::NUMBER_OF_TIMES_TO_RETRY.should == 10
  end

  describe "#process" do
    let(:processor) { described_class.new(form_create_event) }

    before :each do
      EventProcessor.any_instance.stub(:sleep)
    end

    describe "with forms events" do
      before :each do
        FormProcessor.any_instance.should_receive(:process)
      end

      it "handles a create action" do
        processor = described_class.new({'type' => 'form.create'})
        processor.process
      end

      it "handles an update action" do
        processor = described_class.new({'type' => 'form.update'})
        processor.process
      end

      it "handles a delete action" do
        processor = described_class.new({'type' => 'form.delete'})
        processor.process
      end

      it "handles a bogus action" do
        processor = described_class.new({'type' => 'form.bogus'})
        processor.process
      end
    end

    describe "with record events" do
      before :each do
        RecordProcessor.any_instance.should_receive(:process)
      end

      it "handles a create action" do
        processor = described_class.new({'type' => 'record.create'})
        processor.process
      end

      it "handles an update action" do
        processor = described_class.new({'type' => 'record.update'})
        processor.process
      end

      it "handles a delete action" do
        processor = described_class.new({'type' => 'record.delete'})
        processor.process
      end

      it "handles a bogus action" do
        processor = described_class.new({'type' => 'record.bogus'})
        processor.process
      end
    end

    it "accepts unknown events" do
      processor = described_class.new(test_event)
      processor.process.should == Status::ACCEPTED
    end

    describe "with bad event data" do
      describe "that isn't a hash" do
        it "raises an error" do
          empty_string = ""
          expect{described_class.new(empty_string)}.to raise_error(TypeError)
        end
      end

      describe "that doesn't have a type" do
        it "raises an error" do
          empty_hash = {}
          expect{described_class.new(empty_hash)}.
            to raise_error(ArgumentError)
        end
      end

      describe "that doesn't have a valid type" do
        it "raises an error" do
          invalid_event_type = {'type' => 'bad#event'}
          expect{described_class.new(invalid_event_type)}.
            to raise_error(ArgumentError)
        end
      end
    end

    describe "when failing to process an event" do
      let(:num_of_retries)    { described_class::NUMBER_OF_TIMES_TO_RETRY }

      it "returns an internal error status" do
        FormProcessor.any_instance.stub(:process).and_raise(StandardError)

        processor.process.should == Status::INTERNAL_ERROR
      end

      it "retries multiple times" do
        form_double =
          double("form_processor").tap{|d|
            # The erroring call is retried multiple times.
            d.should_receive(:process).
              exactly(num_of_retries).times.
              and_raise(StandardError)
          }
        FormProcessor.stub(:new).and_return(form_double)

        processor.process.should == Status::INTERNAL_ERROR
      end

      it "sleeps when it retries" do
        FormProcessor.any_instance.stub(:process).and_raise(StandardError)
        processor.should_receive(:sleep).
          exactly(num_of_retries).times

        processor.process.should == Status::INTERNAL_ERROR
      end
    end

    describe "when successfully processing an event" do
      def stub_form_create
        FormProcessor.any_instance.stub(:process).and_return(Status::CREATED)
      end

      def stub_form_delete
        FormProcessor.any_instance.stub(:process).
          and_return(Status::NO_CONTENT)
      end

      it "returns the successful status code" do
        stub_form_create

        processor.process.should == Status::CREATED
      end

      it "prevents rate limiting when status is CREATED" do
        stub_form_create
        processor.should_receive(:sleep).exactly(:once)

        processor.process.should == Status::CREATED
      end

      it "prevents rate limiting when status is NO_CONTENT" do
        stub_form_delete
        processor.should_receive(:sleep).exactly(:once)

        processor.process.should == Status::NO_CONTENT
      end
    end
  end
end

