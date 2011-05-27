class Capture < ActiveRecord::Base
  belongs_to :node
  belongs_to :runner
  belongs_to :game
  belongs_to :team
  
  before_save :start_game_if_not_started
  before_save :assign_team_from_runner
  after_create :update_aggregate_times!
  
  validates_presence_of :game, :runner, :node, :team, :message => "can't be found"
  validate :game_is_active
#  validate :mobile_number_is_valid
 
 def parse_sms
   # command_words = %w[join, game, abort, end,]
 end
  
  private
  def game_is_active
    errors.add(:game, 'must be active') unless game && game.is_active?
  end
  
  def mobile_number_is_valid
    errors.add(:runner, 'must have valid mobile number') unless runner && runner.mobile_number =~ /^(?:(\d)[ \-\.]?)?(?:\(?(\d{3})\)?[ \-\.])?(\d{3})[ \-\.](\d{4})(?: ?x?(\d+))?$/    
  end
  
  def start_game_if_not_started
    game = self.game
    if !game.has_started? && game.first_capture? 
      game.start!
    end
  end
  
  #ensure that team is associated with capture
  def assign_team_from_runner
    self.team ||= self.runner.team # same as self.team = self.runner.team if self.team.nil?
  end
  
  def update_aggregate_times!
    self.game.update_aggregate_times!
  end
  
end
