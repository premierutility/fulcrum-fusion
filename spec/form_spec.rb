require 'spec_helper'

describe Form do
  describe "#fiend_field_by_key" do
    subject { described_class.new('fakeid').find_field_by_key('94f8') }

    it "returns nothing if it can't find the form" do
      Fulcrum::Form.stub(:find)
      subject.should be_nil
    end

    it "returns the field data if the form and field exists" do
      expected_field =
        {
          'key'   => '94f8',
          'label' => 'Name',
          'type'  => 'TextField'
        }
      Fulcrum::Form.stub(:find).and_return(
        {
          'form' =>
            {
              'elements' =>
                [ expected_field ]
            }
        }
      )
      subject.should == expected_field
    end

    it "returns the nil if the form and field exists" do
      field =
        {
          'key'   => 'other',
          'label' => 'Other',
          'type'  => 'TextField'
        }
      Fulcrum::Form.stub(:find).and_return(
        {
          'form' =>
            {
              'elements' => [ field ]
            }
        }
      )
      subject.should be_nil
    end
  end
end

