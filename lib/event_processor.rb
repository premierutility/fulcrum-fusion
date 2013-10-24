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

    try_count = 0
    until processed || try_count == 10
      begin
        status = event.process
        sleep 1 if status == 201 || status == 204 # To prevent rate-limiting
      rescue StandardError => e
        puts "ERROR: #{e.inspect} : #{e.message}\n\n#{e.backtrace}"
        try_count += 1
        sleep 2
      else
        processed = true
      end
    end

    status
  end

private
  PROCESSORS = { 'form' => FormProcessor, 'record' => RecordProcessor }.freeze

  def event
    return @event if @event

    klass = PROCESSORS[@resource]
    return unless klass

    @event = klass.new(@action, @event_data)
  end

  def event_type
    @event_data["type"]
  end

  def parse_event
    event_type.split('.')
  end
end

