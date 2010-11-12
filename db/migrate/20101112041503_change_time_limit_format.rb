class ChangeTimeLimitFormat < ActiveRecord::Migration
  def self.up
    remove_column :games, :time_limit
    add_column :games, :time_limit, :integer
  end

  def self.down
    remove_column :games, :time_limit
    add_column :games, :time_limit, :time
  end
end
