class CreateRunnersTeamsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :runners_teams, :id => false do |t|
      t.references :runner, :team
    end
    remove_column :runners, :team_id
  end

  def self.down
    add_column :runners, :team_id, :integer
    drop_table :runners_teams
  end
end
