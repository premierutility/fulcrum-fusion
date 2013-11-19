module Helpers
  module StubServicesHelper
    def stub_fusion_show_tables(tables=[])
      GData::Client::FusionTables.any_instance.stub(:show_tables).
        and_return(tables)
    end

    def stub_fusion_create_table(table=Object.new)
      GData::Client::FusionTables.any_instance.
        stub(:create_table).and_return(table)
    end

    def stub_fusion_drop(number_tables_dropped=1)
      GData::Client::FusionTables.any_instance.
        stub(:drop).and_return(number_tables_dropped)
    end
  end
end

