class Runner < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :captures

  # couldn't figure out how to retrieve the user's games through associations,
  # so just collect the games from each team here
  def games
    self.teams.map{|team| team.game }
  end
  
  validates_presence_of :mobile_number
#  validates_format_of :mobile_number, :with => /^(?:(\d)[ \-\.]?)?(?:\(?(\d{3})\)?[ \-\.])?(\d{3})[ \-\.](\d{4})(?: ?x?(\d+))?$/
  
  def assign_to_smallest_team(game)    
    self.current_team = game.smallest_team
  end
  
  def join_game_auto_assign_team!
    game = Game.unstarted_games.last
    self.assign_to_smallest_team(game)
    self.save!
  end
  
  def captures_in_current_game
    game_id = self.current_game.id
    self.captures.find_all_by_game_id(game_id)
  end
  
  def join_team!(team_name)
    team = Team.find_by_name(team_name.downcase)
    if team
      self.current_team = team
      self.save!
    else
      raise 'team not found'
    end
  end
  
  def current_team
    #TODO this will show as current team even after the game has ended
    self.teams.last
  end
  
  def current_team=(team)
    self.team = team
  end
  
  def team=(team)
    self.teams << team
  end
  
  def current_game
    # self.games.where(:id => Game.active_game).last
    game = self.games.last
    game.has_ended? ? nil : game
  end
  
  def capture(node)
    self.captures.create(:node => node, :game => self.current_game, :team => self.current_team)
  end
  
end
