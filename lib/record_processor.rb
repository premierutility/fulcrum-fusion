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
    @record_row = RecordData.new(@event_data['data']).to_fusion_format

    id = FormUtils.id(@event_data['data']['form_id'])
    @table = FulcrumTable.new(id).table
  end

  def process
    return 202 unless action

    action.process
  end

private
  def action
    # The record is for a table that doesn't exist, so don't process it.
    return nil unless @table

    return @action if @action

    case @action_name
    when 'create'
      klass = RecordCreator

    when 'update'
      klass = RecordUpdater

    when 'delete'
      klass = RecordDeleter

    else
      return nil
    end

    @action = klass.new(@table, @record_row)
  end
end

