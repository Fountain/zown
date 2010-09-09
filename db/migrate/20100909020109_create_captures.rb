class CreateCaptures < ActiveRecord::Migration
  def self.up
    create_table :captures do |t|
      t.integer :game_id
      t.integer :runner_id
      t.integer :node_id
      t.datetime :captured_at

      t.timestamps
    end
  end

  def self.down
    drop_table :captures
  end
end
