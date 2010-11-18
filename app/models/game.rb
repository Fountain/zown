class Game < ActiveRecord::Base
  has_many :captures
  has_many :teams
  has_many :nodes
  has_many :runners, :through => :teams
  
  before_create :create_teams
  after_create :reset_nodes
  
  attr_accessor :number_of_teams
  attr_accessor :auto_assign_runners
    
  # MAX_NUMBER_OF_TEAMS = 2
  TEAM_NAMES = ['Red', 'Blue', 'Green', 'Yellow']
  
  # before creating a new game check to see if one is currently in progress
  def check_for_active_game
    # TODO
  end
  
  #reset ownership of all nodes after the game is created
  def reset_nodes
    # TODO
  end
  
  def winning_team
    max = self.cumulative_team_times.max do |ob1, ob2|
      time1 = ob1[1]
      time2 = ob2[1]
      time1 <=> time2
    end
    # [team, time]
    max[0] # team
  end
  
  def create_teams
    number_of_teams.to_i.times do |i|
      self.teams << Team.create(:name => TEAM_NAMES[i])
    end
  end
  
  # returns a hash of teams and total times
  def cumulative_team_times
    # get all nodes in this game
    nodes = self.nodes
    # create team times holder
    times = {}
    self.teams.each {|team| times[team] = 0}
    # run cumulative_time on each
    nodes.each do |node|
      node_times = node.cumulative_time
      # add up cumulative times and assign to each team
      node_times.each {|team, time| times[team] += time }
    end
    # return hash of team times
    times
  end
  
  def start!
    # TODO launch cron job?
    self.start_time = Time.now
    self.save!   
  end
  
  def add_cluster(cluster)
    cluster.nodes.each do |node|
      nodes << node
    end
  end
  
  def end_time
    self.start_time + self.time_limit.minutes if self.start_time and self.time_limit
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
