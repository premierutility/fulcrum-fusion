require_relative 'fulcrum_table'
require_relative 'record_processor/base'
require_relative 'record_processor/record_creator'
require_relative 'record_processor/record_updater'
require_relative 'record_processor/record_deleter'
require_relative 'record_data'

class RecordProcessor
  def initialize(action_name, event_data)
    @action_name = action_name
    @event_data  = event_data
    @record_data = RecordData.new(@event_data['data'])

    id = FormUtils.id(@event_data['data']['form_id'])
    @table = FulcrumTable.new(id).table
  end

  def process
    return 202 unless action

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
    # The record is for a table that doesn't exist, so don't process it.
    return nil unless @table

    return @action if @action

    klass = ACTIONS[@action_name]
    return unless klass

    @action = klass.new(@table, @record_data)
  end
end

