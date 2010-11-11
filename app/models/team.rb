class Team < ActiveRecord::Base
  has_many :runners
  belongs_to :game
  has_many :captures, :through => :runners
end
