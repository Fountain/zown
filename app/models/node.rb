class Node < ActiveRecord::Base
  has_many :captures
  has_many :clusters
end
