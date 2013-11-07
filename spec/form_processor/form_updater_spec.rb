require 'spec_helper'

describe FormProcessor::FormUpdater do
  let(:processor) { described_class.new }
  describe "#process" do
    it "accepts any update" do
      processor.process.should == Status::ACCEPTED
    end
  end
end

