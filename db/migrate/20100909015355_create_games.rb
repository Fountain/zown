class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :creator_id
      t.time :time_limit
      t.boolean :security
      t.integer :capture_limit
      t.datetime :start_time

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
