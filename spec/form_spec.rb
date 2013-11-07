require 'spec_helper'

describe Form do
  describe "#field_key_name_mappings" do
    subject { described_class.new('fakeid').field_key_name_mappings }

    it "returns nothing if it can't find the form" do
      Fulcrum::Form.stub(:find)
      subject.should be_nil
    end

    it "returns the mappings if the form exists" do
      Fulcrum::Form.stub(:find).
        and_return(
          {
            'form' => 
              {
                'elements' =>
                  [
                    { 'key' => 'abcd', 'label' => 'one' },
                    { 'key' => 'cdef', 'label' => 'two' }
                  ]
              }
          }
        )

      subject.should == {'abcd' => 'one', 'cdef' => 'two' }
    end
  end
end

