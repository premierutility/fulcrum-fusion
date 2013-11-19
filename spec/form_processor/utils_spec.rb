require 'spec_helper'

describe FormProcessor::Utils do
  describe "::id" do
    it "should remove dashes" do
      string_with_dashes = "this-string-has-dashes"
      described_class.id(string_with_dashes).should == "thisstringhasdashes"
    end
  end
end
