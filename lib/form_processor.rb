require_relative 'form_processor/form_creator'
require_relative 'form_processor/form_updater'
require_relative 'form_processor/form_deleter'

class FormProcessor
  def initialize(action_name, event_data)
    @action_name = action_name
    @event_data = event_data
  end

  def process
    return 202 unless action

    processed = false

    until processed
      begin
        action.process
      rescue StandardError => e
        puts "ERROR: #{e.message} : #{e.backtrace}"
      else
        processed = true
      end
    end
  end

private
  def action
    return @action if @action

    case @action_name
    when 'create'
      instance = FormCreator.new(form_id, @event_data)

    when 'update'
      instance = FormUpdater.new

    when 'delete'
      instance = FormDeleter.new(form_id)

    else
      return nil # This isnt an event we care about
    end

    @action = instance
  end

  def form_id
    @event_data["data"]["id"].gsub("-", "")
  end
end

