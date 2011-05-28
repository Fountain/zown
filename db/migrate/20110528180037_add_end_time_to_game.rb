class AddEndTimeToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :end_time, :datetime
  end

  def self.down
    remove_column :games, :end_time
  end
end
