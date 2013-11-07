require 'spec_helper'

describe Status do
  it "has a CREATED status" do
    described_class::CREATED.should == 201
  end

  it "has an ACCEPTED status" do
    described_class::ACCEPTED.should == 202
  end

  it "has a NO_CONTENT status" do
    described_class::NO_CONTENT.should == 204
  end

  it "has a BAD_REQUEST status" do
    described_class::BAD_REQUEST.should == 400
  end

  it "has a INTERNAL_ERROR status" do
    described_class::INTERNAL_ERROR.should == 500
  end
end

