RSpec.configure{|c| c.include Helpers::StubServicesHelper }

module SharedContexts
  module StubServicesSharedContext
    shared_context "stub fusion tables" do
      before :each do
        GData::Client::FusionTables.any_instance.stub(:clientlogin)
        GData::Client::FusionTables.any_instance.stub(:set_api_key)
        stub_fusion_show_tables
      end
    end

    shared_context "stub fulcrum" do
      before :each do
        Fulcrum::Form.stub(:find)
      end
    end

    shared_context "stub fulcrum with form" do
      before :each do
        Fulcrum::Form.stub(:find).
          and_return(
            {
              'form'=>
                {
                  'elements'=>
                    [
                      {'key'=>'94f8', 'data_name'=>'name', 'type' => 'TextField'},
                      {'key'=>'876d', 'data_name'=>'fake', 'type' => 'TextField'}
                    ]
                }
            }
        )
      end
    end

    shared_context "stub objects" do
      let(:stub_record) { Object.new }

      let(:stub_records) { [stub_record] }

      let(:table_name) { "table name" }

      let(:stub_table) do
        Struct.new(:name).new(table_name).
          tap{|s| s.stub(:select).and_return(stub_records) }
      end

      let(:stub_table_with_no_records) do
        Struct.new(:name).new(table_name).
          tap{|s| s.stub(:select).and_return([]) }
      end

      let(:stub_tables) do
        [].tap{|a| a.stub(:select).and_return([stub_table]) }
      end
    end
  end
end

