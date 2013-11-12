require 'spec_helper'

RSpec.configure{|c| c.include SharedContexts::StubServicesSharedContext }
RSpec.configure{|c| c.include Helpers::StubServicesHelper }

describe FulcrumFusion do
  describe "GET /" do
    it "shows it's running" do
      get '/'
      last_response.body.should == "Fulcrum Fusion is running"
    end
  end

  describe "POST /" do
    it "accepts events at the root" do
      post '/', '{"type":"test.test"}'
      last_response.status.should == Status::ACCEPTED
    end

    describe "with bad POST data" do
      it "rejects missing POST data" do
        post '/'
        last_response.status.should == Status::BAD_REQUEST
      end

      it "rejects empty POST data" do
        post '/', ""
        last_response.status.should == Status::BAD_REQUEST
      end

      it "rejects invalid JSON" do
        post '/', "}{This is bad JSON'''"
        last_response.status.should == Status::BAD_REQUEST
      end

      it "rejects event data with no hash" do
        post '/', '[1,2,3]'
        last_response.status.should == Status::BAD_REQUEST
      end

      it "rejects event data hash without a type key" do
        post '/', '{"key":"value"}'
        last_response.status.should == Status::BAD_REQUEST
      end

      it "rejects event data hash a bad type valye" do
        post '/', '{"type":"bad#Type"}'
        last_response.status.should == Status::BAD_REQUEST
      end
    end

    describe "with valid POST data" do
      include_context "stub objects"
      include_context "stub fusion tables"

      describe "with a form event" do
        before :each do
          EventProcessor.any_instance.stub(:sleep)
        end

        let(:form_post) do
          post '/', '{"type":"form.'+@action.to_s+'","data":{"id":"randomhex","name":"Test Form","elements":{}}}'
        end

        it "creates a new form" do
          stub_fusion_create_table
          @action = :create
          form_post
          last_response.status.should == Status::CREATED
        end

        it "doesn't create a duplicate form" do
          stub_fusion_create_table(nil)
          @action = :create
          form_post
          last_response.status.should == Status::ACCEPTED
        end

        it "handles a form update" do
          @action = :update
          form_post
          last_response.status.should == Status::ACCEPTED
        end

        it "deletes an existing form" do
          stub_fusion_show_tables(stub_tables)
          stub_fusion_drop
          @action = :delete
          form_post
          last_response.status.should == Status::NO_CONTENT
        end

        it "doesn't delete a non-existant form" do
          stub_fusion_show_tables
          @action = :delete
          form_post
          last_response.status.should == Status::ACCEPTED
        end

        it "handles a bogus event" do
          @action = :bogus
          form_post
          last_response.status.should == Status::ACCEPTED
        end
      end

      describe "with a record event" do
        include_context "stub fulcrum"

        before :each do
          EventProcessor.any_instance.stub(:sleep)
          fake_table = GData::Client::FusionTables.new
          fake_tables = [].tap{|a| a.stub(:select).and_return([fake_table]) }
          stub_fusion_show_tables(fake_tables)
        end

        let(:fake_row) { {rowid: "fakerowid"} }

        let(:record_post) do
          post '/', '{"type":"record.'+@action.to_s+'","data":{"id":"randomhex","form_id":"anotherrandomhex","latitude":0,"longitude":0,"form_values":{}}}'
        end

        it "creates a new record" do
          GData::Client::FusionTables.any_instance.stub(:select).
            and_return([])
          GData::Client::FusionTables.any_instance.stub(:insert)
          @action = :create
          record_post
          last_response.status.should == Status::CREATED
        end

        it "doesn't create a duplicate record" do
          GData::Client::FusionTables.any_instance.stub(:select).
            and_return([fake_row])
          @action = :create
          record_post
          last_response.status.should == Status::ACCEPTED
        end

        it "updates a record" do
          GData::Client::FusionTables.any_instance.stub(:select).
            and_return([fake_row])
          GData::Client::FusionTables.any_instance.stub(:update)
          @action = :update
          record_post
          last_response.status.should == Status::NO_CONTENT
        end

        it "doesn't update a non-existant record" do
          GData::Client::FusionTables.any_instance.stub(:select).
            and_return([])
          @action = :update
          record_post
          last_response.status.should == Status::ACCEPTED
        end

        it "deletes an existing record" do
          GData::Client::FusionTables.any_instance.stub(:select).
            and_return([fake_row])
          GData::Client::FusionTables.any_instance.stub(:delete)
          @action = :delete
          record_post
          last_response.status.should == Status::NO_CONTENT
        end

        it "doesn't delete a non-existant record" do
          GData::Client::FusionTables.any_instance.stub(:select).
            and_return([])
          @action = :delete
          record_post
          last_response.status.should == Status::ACCEPTED
        end

        it "handles a bogus event" do
          @action = :bogus
          record_post
          last_response.status.should == Status::ACCEPTED
        end
      end
    end
  end
end

