class CreateCodes < ActiveRecord::Migration
  def self.up
    create_table :codes do |t|
      t.string :contents
      t.integer :node_id

      t.timestamps
    end
  end

  def self.down
    drop_table :codes
  end
end
