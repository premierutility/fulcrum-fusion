require_relative 'form_processor'
require_relative 'record_processor'
require_relative 'status'

class EventProcessor
  NUMBER_OF_TIMES_TO_RETRY = 10

  def initialize(event_data)
    unless event_data && event_data.is_a?(Hash)
      raise TypeError, "Event data must be a hash"
    end

    @event_data = event_data

    unless is_valid_event?(event_data)
      raise ArgumentError, 'Event data hash must have a `type` key with a valud of the format `<resource>.<action>`'
    end

    @resource, @action = parse_event
  end

  def process
    puts "Processing event: #{event_type}"

    # This isn't an event we want to process.
    return Status::ACCEPTED unless event

    processed = false

    try_count = 0
    until processed || try_count == 10
      begin
        status = event.process

        prevent_rate_limiting if need_to_prevent_rate_limiting?(status)

      rescue StandardError => e
        puts "Error when processing event:"
        puts "Error: #{e.inspect} - #{e.message}"
        puts "Backtrace:"
        puts e.backtrace
        try_count += 1

        prevent_rate_limiting
      else
        processed = true
      end
    end

    status || Status::INTERNAL_ERROR
  end

private
  PROCESSORS =
    {
      'form'   => FormProcessor,
      'record' => RecordProcessor
    }.freeze

  def event
    return @event if @event

    klass = PROCESSORS[@resource]
    return unless klass

    @event = klass.new(@action, @event_data)
  end

  def is_valid_event?(event_data)
    @event_data["type"] && @event_data["type"].match(/^.+\..+$/)
  end

  def event_type
    @event_data["type"]
  end

  def parse_event
    event_type.split('.')
  end

  def need_to_prevent_rate_limiting?(status)
    status == Status::CREATED || status == Status::NO_CONTENT
  end

  def prevent_rate_limiting
    sleep 2
  end
end

