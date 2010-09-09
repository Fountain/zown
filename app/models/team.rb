class Team < ActiveRecord::Base
  has_many :runners
  belongs_to :game
end
