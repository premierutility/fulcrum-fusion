require 'spec_helper'

describe Form do
  describe "#fiend_field_by_key" do
    subject { described_class.new('fakeid').find_field_by_key('94f8') }

    describe "where it can't find the form" do
      it "returns nil" do
        Fulcrum::Form.stub(:find)
        subject.should be_nil
      end
    end

    describe "where the form and field exist" do
      describe "where the field is not in a section" do
        it "returns the field data" do
          expected_field =
            {
              'key'   => '94f8',
              'data_name' => 'name',
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
      end

      describe "where the field is inside a section" do
        it "returns the field data" do
          expected_field =
            {
              'key'   => '94f8',
              'data_name' => 'name',
              'type'  => 'TextField'
            }
          Fulcrum::Form.stub(:find).and_return(
            {
              'form' =>
                {
                  'elements' =>
                    [ {
                        'key' => '2222',
                        'data_name' => 'sectiony',
                        'type' => 'Section',
                        'elements' => [ expected_field ]
                      }
                    ]
                }
            }
          )
          subject.should == expected_field
        end
      end
    end

    describe "where the form exists but the field does not" do
      it "returns nil" do
        field =
          {
            'key'   => 'other',
            'data_name' => 'other',
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
end

