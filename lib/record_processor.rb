require_relative 'fulcrum_table'
require_relative 'form_processor/utils'
require_relative 'record_processor/base'
require_relative 'record_processor/record_creator'
require_relative 'record_processor/record_updater'
require_relative 'record_processor/record_deleter'
require_relative 'record_data'
require_relative 'status'

class RecordProcessor
  def initialize(action_name, event_data)
    @action_name = action_name
    @event_data  = event_data
  end

  def process
    id = FormProcessor::Utils.id(@event_data['data']['form_id'])
    @table = FulcrumTable.new(id).table

    fulcrum_form = Form.new(@event_data['data']['form_id'])

    # The record is for a table that doesn't exist, so don't process it.
    return Status::ACCEPTED unless @table && fulcrum_form.form_exists?

    @record_data = RecordData.new(fulcrum_form, @event_data['data'])

    return Status::ACCEPTED unless action

    action.process
  end

private
  ACTIONS =
    {
      'create' => RecordCreator,
      'update' => RecordUpdater,
      'delete' => RecordDeleter
    }.freeze

  def action
    unless @action
      klass = ACTIONS[@action_name]
      return nil unless klass

      @action = klass.new(@table, @record_data)
    end

    @action
  end
end

