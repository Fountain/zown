class AddCodeToCapture < ActiveRecord::Migration
  def self.up
    add_column :captures, :code, :integer
  end

  def self.down
    remove_column :captures, :code
  end
end
