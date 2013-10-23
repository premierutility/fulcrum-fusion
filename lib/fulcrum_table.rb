require 'fusion_tables'
require 'forwardable'
require_relative 'system_columns'
require_relative '../config.rb' if File.exists?('config.rb')

class FulcrumTable
  extend Forwardable
  def_delegator :table, :insert
  def_delegator :table, :update
  def_delegator :table, :delete
  def_delegator :table, :select

  attr_accessor :table

  def initialize(table_name)
    configure_fusion_tables

    @table_name = table_name.to_s
    retrieve_table
  end

  def create_table(user_columns)
    return if table_exists?

    all_columns = all_columns_with_users_first(user_columns)
    self.table = @ft.create_table(@table_name, all_columns)
  end

  def drop_table
    return unless table_exists?

    num_tables_dropped = @ft.drop(Regexp.new(@table_name))

    if table_was_dropped?(num_tables_dropped)
      table
    else
      nil
    end
  end

  private
    def configure_fusion_tables
      @ft = GData::Client::FusionTables.new
      @ft.clientlogin ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASSWORD']
      @ft.set_api_key ENV['GOOGLE_API_KEY']
    end

    def retrieve_table
      tables = @ft.show_tables
      self.table =
        tables.select{|t| t.name.match(Regexp.new(@table_name))}.first
    end

    def table_exists?
      !!table
    end

    def all_columns_with_users_first(user_columns)
      user_columns.concat(SystemColumns.data)
    end

    def table_was_dropped?(num_tables_dropped)
      num_tables_dropped == 1
    end
end

