class CreateClusters < ActiveRecord::Migration
  def self.up
    create_table :clusters do |t|
      t.integer :user_id
      t.string :name
      t.integer :game_id

      t.timestamps
    end
  end

  def self.down
    drop_table :clusters
  end
end
