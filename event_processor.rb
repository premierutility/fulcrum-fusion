require './fulcrum_table'
require './form_processor'
require './record_processor'

class EventProcessor
  def process(event_data)
    event_name = event_data["type"]
    resource, action = *(event_name.split('.'))
    puts "Processing event: #{event_name}"
    case resource
    when 'form'
      FormProcessor.new.process(action, event_data)
    when 'record'
      RecordProcessor.new.process(action, event_data)
    end
  end

end

