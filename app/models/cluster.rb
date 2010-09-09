class Cluster < ActiveRecord::Base
  has_many :nodes
end
