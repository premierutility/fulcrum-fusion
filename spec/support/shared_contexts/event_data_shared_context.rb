module SharedContexts
  module EventDataSharedContext
    shared_context "event data" do
      let(:form_event_data) do
        {
          "id" => "f4ef6656-172c",
          "type" => "form.#{@action.to_s}",
          "owner_id" => "00053caf-4b6e",
          "data" => {
            "name" => "Fake Form",
            "description" => "Intersection in Colorado Springs",
            "bounding_box" => nil,
            "record_title_key" => "94f8",
            "status_field" => { },
            "id" => "295eda4a-7795",
            "record_count" => 0,
            "created_at" => "2013-09-21T19:18:55Z",
            "updated_at" => "2013-09-21T19:18:55Z",
            "elements" => [
              {
                "type" => "TextField",
                "key" => "94f8",
                "label" => "Name",
                "description" => nil,
                "required" => false,
                "disabled" => false,
                "hidden" => false,
                "data_name" => "name",
                "default_value" => nil,
                "visible_conditions_type" => nil,
                "visible_conditions" => nil,
                "required_conditions_type" => nil,
                "required_conditions" => nil,
                "numeric" => false
              }
            ]
          }
        }
      end

      let(:record_event_data) do
        {
          "id" => "4ef6656f-72c1",
          "form_id" => 'add43973-3ee5',
          "type" => "record.#{@action.to_s}",
          "owner_id" => "00053caf-4b6e",
          "data" =>
            {
              'status' => nil,
              'version' => 1,
              'id' => '7553fd44-78bb',
              'form_id' => '295eda4a-7795',
              'project_id' => nil,
              'created_at' => '2013-09-21T19:20:16Z',
              'updated_at' => '2013-09-21T19:20:16Z',
              'client_created_at' => '2013-09-21T19:20:16Z',
              'client_updated_at' => '2013-09-21T19:20:16Z',
              'created_by' => 'dev Test',
              'created_by_id' => '960247b1',
              'updated_by' => 'dev Test',
              'updated_by_id' => '960247b1',
              'assigned_to' => nil,
              'assigned_to_id' => nil,
              'form_values' => {
                '94f8' => 'Fake Record'
              },
              'latitude' => 38.8968321491252,
              'longitude' => -104.831140637398,
              'altitude' => nil,
              'speed' => nil,
              'course' => nil,
              'horizontal_accuracy' => nil,
              'vertical_accuracy' => nil,
              'extra_hash_key' => 0
            }
        }
      end

      let(:record_data) { record_event_data['data'] }

      let(:record_fusion_data) do
        {
          'name' => 'Fake Record',
          'status' => nil,
          'version' => 1,
          'id' => '7553fd44-78bb',
          'form_id' => '295eda4a-7795',
          'project_id' => nil,
          'created_at' => '2013-09-21T19:20:16Z',
          'updated_at' => '2013-09-21T19:20:16Z',
          'client_created_at' => '2013-09-21T19:20:16Z',
          'client_updated_at' => '2013-09-21T19:20:16Z',
          'created_by' => 'dev Test',
          'created_by_id' => '960247b1',
          'updated_by' => 'dev Test',
          'updated_by_id' => '960247b1',
          'assigned_to' => nil,
          'assigned_to_id' => nil,
          'form_values' =>
            "{\"94f8\":\"Fake Record\"",
          'location' => '38.8968321491252,-104.831140637398',
          'altitude' => nil,
          'speed' => nil,
          'course' => nil,
          'horizontal_accuracy' => nil,
          'vertical_accuracy' => nil
        }
      end

      let(:record_raw_data) do
        {
          'status' => nil,
          'version' => 1,
          'id' => '7553fd44-78bb',
          'form_id' => '295eda4a-7795',
          'project_id' => nil,
          'created_at' => '2013-09-21T19:20:16Z',
          'updated_at' => '2013-09-21T19:20:16Z',
          'client_created_at' => '2013-09-21T19:20:16Z',
          'client_updated_at' => '2013-09-21T19:20:16Z',
          'created_by' => 'dev Test',
          'created_by_id' => '960247b1',
          'updated_by' => 'dev Test',
          'updated_by_id' => '960247b1',
          'assigned_to' => nil,
          'assigned_to_id' => nil,
          'form_values' =>
            "{\"94f8\":\"Fake Record\"}",
          'location' => '38.8968321491252,-104.831140637398',
          'altitude' => nil,
          'speed' => nil,
          'course' => nil,
          'horizontal_accuracy' => nil,
          'vertical_accuracy' => nil
        }
      end

      let(:bad_record_data) do
        record_data.
          tap do |d|
            d['form_values'].merge!({'876d' => 'ninja turtles'})
          end
      end

      let(:bad_record_fusion_data) do
        record_fusion_data.dup.
          tap do |d|
            d['fake'] = 'ninja turtles'
            d['form_values'] =
              "{\"94f8\":\"Fake Record\",\"876d\":\"ninja turtles\"}"
          end
      end

      let(:bad_record_raw_data) do
        record_raw_data.dup.
          tap do |d|
            d['form_values'] =
              "{\"94f8\":\"Fake Record\",\"876d\":\"ninja turtles\"}"
          end
      end
    end
  end
end

