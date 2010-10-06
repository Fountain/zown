class Game < ActiveRecord::Base
  has_many :captures
  has_many :teams
  has_many :nodes
  has_many :runners, :through => :teams
  
  def add_cluster(cluster)
    cluster.nodes.each do |node|
      nodes << node
    end
  end
end
