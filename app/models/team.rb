class Team < ActiveRecord::Base
  has_many :runners, :dependent => :nullify
  belongs_to :game
  has_many :captures
  has_many :nodes, :through => :captures
  
  default_value_for :aggregate_time, 0 
  
  def to_s
    "Team " + self.name.capitalize if self.name
  end
end

  
