require 'spec_helper'

describe EventData do
  describe "::BadDataError" do
    it "should exist" do
      described_class::BadDataError.should be
    end
  end

  let(:json) { '{"type":"test.test"}' }
  subject { described_class.new(json) }

  describe "#initialize" do
    it "throws exception with no JSON" do
      expect{described_class.new(nil)}.to raise_error(TypeError)
    end
  end

  describe "#read" do
    it "throws exception with bad JSON" do
      json = '}{"test"'
      expect{described_class.new(json).read}.
        to raise_error(described_class::BadDataError)
    end

    it "returns valid data with valid JSON" do
      described_class.new(json).read.should eq({ 'type' => 'test.test' })
    end
  end
end

