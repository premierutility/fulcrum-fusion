require 'spec_helper'

describe FormProcessor do
  let(:processor) { described_class.new(@action.to_s, event_data) }
  let(:event_data) { {'data' => { 'id' => 'fakeid'} } }

  it "processes form create events" do
    @action = :create
    FormProcessor::FormCreator.any_instance.
      should_receive(:process).
      and_return(Status::CREATED)
    processor.process.should == Status::CREATED
  end

  it "processes form update events" do
    @action = :update
    FormProcessor::FormUpdater.any_instance.
      should_receive(:process).
      and_return(Status::NO_CONTENT)
    processor.process.should == Status::NO_CONTENT
  end

  it "processes form delete events" do
    @action = :delete
    FormProcessor::FormDeleter.any_instance.
      should_receive(:process).
      and_return(Status::NO_CONTENT)
    processor.process.should == Status::NO_CONTENT
  end

  it "ignores bogus form events" do
    @action = :bogus
    processor.process.should == Status::ACCEPTED
  end
end
