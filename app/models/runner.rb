class Runner < ActiveRecord::Base
  belongs_to :team
  has_many :captures
  has_one :game, :through => :team
  
  def assign_to_smallest_team!
    game = Game.active_game    
    self.team = game.smallest_team
    self.save     
  end
  
end
