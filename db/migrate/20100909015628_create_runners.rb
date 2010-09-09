class CreateRunners < ActiveRecord::Migration
  def self.up
    create_table :runners do |t|
      t.integer :mobile_number
      t.integer :team_id

      t.timestamps
    end
  end

  def self.down
    drop_table :runners
  end
end
