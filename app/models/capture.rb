class Capture < ActiveRecord::Base
  belongs_to :node
  belongs_to :runner
  belongs_to :game
  has_one :team, :through => :runner
  
  before_save :start_game_if_not_started
  
  validates_presence_of :game, :runner, :node, :message => "can't be found"
  validate :game_is_active 
#  validate :mobile_number_is_valid 
  
  private
  def game_is_active
    errors.add(:game, 'must be active') unless game && game.is_active?
  end
  
  def mobile_number_is_valid
    errors.add(:runner, 'must have valid mobile number') unless runner && runner.mobile_number =~ /^(?:(\d)[ \-\.]?)?(?:\(?(\d{3})\)?[ \-\.])?(\d{3})[ \-\.](\d{4})(?: ?x?(\d+))?$/    
  end
  
  def start_game_if_not_started
    game = self.game
    if game.is_active? && game.first_capture? 
      game.start_time = Time.now
      game.save
    end
  end
  
end
