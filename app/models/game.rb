class Game < ActiveRecord::Base
  has_many :captures
  has_many :teams
  has_many :nodes
  has_many :runners, :through => :teams

  before_create :create_teams
  after_create :reset_nodes

  attr_accessor :number_of_teams
  attr_accessor :auto_assign_runners

  TEAM_NAMES = ['red', 'blue', 'green', 'yellow', 'purple', 'black', 'white']

  def update_aggregate_times
    # look through all nodes
    nodes = self.nodes
    
    current_time = self.captures.last.created_at
    # for each node, 
    nodes.each do |node|
      previous_capture = self.captures[-2]
      if previous_capture
        team = previous_capture.team
        # compute (current_time - Capture.last.created_at)
        time_to_add = current_time - previous_capture.created_at  
        # update the agg time
        team.aggregate_time += time_to_add
        team.save
      end
    end 
  end

  # schedule end game routine using delayed_job
  def end_after_delay
    self.sleep self.time_limit.minutes  # this surrenders Thread execution, so Heroku might charge less
    self.end!
  end

  # end game routine
  def end!
    #   ...
    puts "The game is over + #{Time.now}"
  end

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

  # check to see if the game is active
  def is_active?
    self.end_time.blank? or Time.now < self.end_time
  end

  # return the team with the least Runners
  def smallest_team
    self.teams.min{|t1,t2| t1.runners.size <=> t2.runners.size }
  end

  # return the active game
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

  # special method for collections weirdness
  def cluster_ids
    []
  end

  # special method for collections weirdness
  def cluster_ids=(ids)
    ids.each do |cluster_id|
      cluster = Cluster.find cluster_id
      self.nodes << cluster.nodes
    end
  end

  # are there any captures yet?
  def first_capture?
    self.captures.empty?
  end
end
