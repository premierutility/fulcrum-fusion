require './fulcrum_table'
require './form_processor'
require './record_processor'

class EventProcessor
  def initialize(event_data)
    @event_data = event_data
    @resource, @action = parse_event
  end

  def process
    puts "Processing event: #{event_type}"

    # This isn't an event we want to process.
    return 202 unless event

    event.process(@action, @event_data)
  end

private
  def event
    case @resource
    when 'form'
      FormProcessor.new
    when 'record'
      RecordProcessor.new
    end
  end

  def event_type
    @event_data["type"]
  end

  def parse_event
    event_type.split('.')
  end
end

