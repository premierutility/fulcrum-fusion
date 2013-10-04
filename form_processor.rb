require './form_creator'
require './form_updater'
require './form_deleter'

class FormProcessor
  def initialize(action_name, event_data)
    @action_name = action_name
    @event_data = event_data
  end

  def process
    action.process
  end

private
  def action
    case @action_name
    when 'create'
      FormCreator.new(form_id, @event_data)

    when 'update'
      FormUpdater.new

    when 'delete'
      FormDeleter.new(form_id)

    else
      202 # This isnt an event we care about
    end
  end

  def form_id
    @event_data["data"]["id"].gsub("-", "")
  end
end

