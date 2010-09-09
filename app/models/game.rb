class Game < ActiveRecord::Base
  has_many :captures
  has_many :teams
end
