require_relative 'form_processor/form_creator'
require_relative 'form_processor/form_updater'
require_relative 'form_processor/form_deleter'
require_relative 'form_processor/utils'
require_relative 'status'

class FormProcessor
  def initialize(action_name, event_data)
    @action_name = action_name
    @event_data = event_data
  end

  def process
    return Status::ACCEPTED unless action

    action.process
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
    FormProcessor::Utils.id(@event_data['data']['id'])
  end
end

