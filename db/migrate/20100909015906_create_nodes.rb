class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.integer :user_id
      t.string :name
      t.text :code_list

      t.timestamps
    end
  end

  def self.down
    drop_table :nodes
  end
end
