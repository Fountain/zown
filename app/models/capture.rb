class Capture < ActiveRecord::Base
  belongs_to :node
  belongs_to :runner
  belongs_to :game
  
  validates_presence_of :game, :runner, :node
  validate :game_is_active
  
  
  private
  def game_is_active
    errors.add(:game, 'must be active') unless game && game.is_active?
  end
end
