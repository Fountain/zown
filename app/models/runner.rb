class Runner < ActiveRecord::Base
  belongs_to :team
  has_many :captures
  has_one :game, :through => :team
  
#  validates_format_of :mobile_number, :with => /^(?:(\d)[ \-\.]?)?(?:\(?(\d{3})\)?[ \-\.])?(\d{3})[ \-\.](\d{4})(?: ?x?(\d+))?$/
  
  def assign_to_smallest_team(game)    
    self.team = game.smallest_team
  end
  
end
