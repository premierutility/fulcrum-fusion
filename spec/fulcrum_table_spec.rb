require 'spec_helper'

RSpec.configure{|c| c.include SharedContexts::StubServicesSharedContext }

describe FulcrumTable do
  include_context "stub fusion tables"
  include_context "stub objects"

  subject { described_class.new(table_name) }

  it "delegates #insert" do
    should respond_to :insert
  end

  it "delegates #update" do
    should respond_to :update
  end

  it "delegates #delete" do
    should respond_to :delete
  end

  it "delegates #select" do
    should respond_to :select
  end

  describe "#create_table" do
    describe "when the table doesn't already exist" do
      it "creates the table" do
        name_column = { name: 'Name', type: 'string' }
        user_columns = [name_column]
        expected_columns = user_columns.concat SystemColumns.data

        GData::Client::FusionTables.any_instance.
          should_receive(:create_table).
          with(table_name, expected_columns).
          and_return(Object.new)
        subject.create_table(user_columns).should_not be_nil
      end
    end

    describe "when the table already exists" do
      it "doesn't create the table" do
        stub_fusion_show_tables([stub_table])
        GData::Client::FusionTables.any_instance.
          should_not_receive(:create_table)
        subject.create_table([]).should be_nil
      end
    end
  end

  describe "#drop_table" do
    describe "when the table doesn't exist" do
      it "doesn't drop anything" do
        GData::Client::FusionTables.any_instance.
          should_not_receive(:drop)
        subject.drop_table.should be_nil
      end
    end

    describe "when the table exists" do
      before :each do
        stub_fusion_show_tables([stub_table])
      end

      describe "and the drop fails" do
        it "returns nil" do
          GData::Client::FusionTables.any_instance.
            should_receive(:drop)
          subject.drop_table.should be_nil
        end
      end

      describe "and the drop succeeds" do
        it "returns the dropped table" do
          GData::Client::FusionTables.any_instance.
            should_receive(:drop).and_return(1)
          subject.drop_table.object_id.should eq stub_table.object_id
        end
      end
    end
  end
end

