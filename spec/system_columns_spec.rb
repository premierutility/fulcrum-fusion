require 'spec_helper'

describe SystemColumns do
  subject { described_class }
  describe "#data" do
    it "is an array of name/type pairs" do
      subject.data.each do |column|
        column.should have_key :name
        column.should have_key :type
      end
    end
  end

  describe "#names" do
    it "is an array of strings" do
      subject.names.each do |name|
        name.should be_a String
      end
    end
  end
end
