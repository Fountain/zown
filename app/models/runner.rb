class Runner < ActiveRecord::Base
  belongs_to :team
  has_many :captures
  has_one :game, :through => :team
  
  validates_presence_of :mobile_number
#  validates_format_of :mobile_number, :with => /^(?:(\d)[ \-\.]?)?(?:\(?(\d{3})\)?[ \-\.])?(\d{3})[ \-\.](\d{4})(?: ?x?(\d+))?$/
  
  def assign_to_smallest_team(game)    
    self.team = game.smallest_team
  end
  
  def join_game_auto_assign_team!
    game = Game.unstarted_games.first
    self.assign_to_smallest_team(game)
    self.save!
  end
  
  def captures_in_current_game
    game_id = self.game.id
    self.captures.find_all_by_game_id(game_id)
  end
  
  def join_team!(team_name)
    team = Team.find_by_name(team_name.downcase)
    if team
      self.team = team
      self.save!
    else
      raise 'team not found'
    end
  end
  
end
