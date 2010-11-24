class AddTeamIdToCaptures < ActiveRecord::Migration
  def self.up
    add_column :captures, :team_id, :integer
  end

  def self.down
    remove_column :captures, :team_id
  end
end
