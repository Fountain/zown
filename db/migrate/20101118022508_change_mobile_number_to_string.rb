class ChangeMobileNumberToString < ActiveRecord::Migration
  def self.up
    remove_column :runners, :mobile_number
    add_column :runners, :mobile_number, :string
  end

  def self.down
    remove_column :runners, :mobile_number
    add_column :runners, :mobile_number, :integer
  end
end
