class Capture < ActiveRecord::Base
  belongs_to :node
  belongs_to :runner
  belongs_to :game
end
