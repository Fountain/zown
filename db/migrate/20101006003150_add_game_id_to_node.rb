class AddGameIdToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :game_id, :integer
  end

  def self.down
    remove_column :nodes, :game_id
  end
end
