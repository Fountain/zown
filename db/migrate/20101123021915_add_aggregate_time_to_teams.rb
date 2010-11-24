class AddAggregateTimeToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :aggregate_time, :integer
  end

  def self.down
    remove_column :teams, :aggregate_time
  end
end
