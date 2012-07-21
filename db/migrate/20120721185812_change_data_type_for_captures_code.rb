class ChangeDataTypeForCapturesCode < ActiveRecord::Migration
  def self.up
    change_table :captures do |t|
      t.change :code, :integer
    end
  end

  def self.down
    change_table :captures do |t|
      t.change :code, :string
    end
  end
end
