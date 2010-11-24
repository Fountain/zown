class Team < ActiveRecord::Base
  has_many :runners, :dependent => :nullify
  belongs_to :game
  has_many :captures
  
  default_value_for :aggregate_time, 0 
  
  def to_s
    "Team " + self.name if self.name
  end
end

  
