require_relative 'form_processor'
require_relative 'record_processor'

class EventProcessor
  def initialize(event_data)
    @event_data = event_data
    @resource, @action = parse_event
  end

  def process
    puts "Processing event: #{event_type}"

    # This isn't an event we want to process.
    return 202 unless event

    processed = false

    until processed
      begin
        status = event.process
        sleep 1 if status == 201 || status == 204 # To prevent rate-limiting
      rescue StandardError => e
        puts "ERROR: #{e.inspect} : #{e.message}\n\n#{e.backtrace}"
        sleep 2
      else
        processed = true
      end
    end

    status
  end

private
  def event
    return @event if @event

    case @resource
    when 'form'
      klass = FormProcessor
    when 'record'
      klass = RecordProcessor
    else
      return nil
    end

    @event = klass.new(@action, @event_data)
  end

  def event_type
    @event_data["type"]
  end

  def parse_event
    event_type.split('.')
  end
end

