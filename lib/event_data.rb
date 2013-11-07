class EventData
  class BadDataError < StandardError; end

  def initialize(json_string)
    unless json_string
      raise(TypeError, "No implicit conversion from nil to string")
    end

    @json_string = json_string
  end

  def read
    begin
      return JSON.parse(@json_string)
    rescue JSON::ParserError
      raise BadDataError, "Could not parse the event data JSON"
    end
  end
end

