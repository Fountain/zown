class Game < ActiveRecord::Base
  has_many :captures
  has_many :teams
  has_many :nodes
  has_many :runners, :through => :teams
    
  # MAX_NUMBER_OF_TEAMS = 2
  
  def start!
    # TODO set start time... launch cron job?
    self.save    
  end
  
  def add_cluster(cluster)
    cluster.nodes.each do |node|
      nodes << node
    end
  end
  
  def end_time
    self.start_time + self.time_limit if self.start_time and self.time_limit
  end
  
  def is_active?
    self.end_time.blank? or Time.now < self.end_time
  end
  
  def smallest_team
    self.teams.min{|t1,t2| t1.runners.size <=> t2.runners.size }
  end
  
  def self.active_game
    games = Game.all
    game = nil
    games.each do |g|
      if g.is_active?
        game = g
        break
      end
    end
    
    game
  end
  
  def cluster_ids
    []
  end
  
  def cluster_ids=(ids)
    ids.each do |cluster_id|
      cluster = Cluster.find cluster_id
      self.nodes << cluster.nodes
    end
  end
  
  def first_capture?
    self.captures.empty?
  end
end
