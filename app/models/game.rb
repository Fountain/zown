class Game < ActiveRecord::Base
  has_many :captures
  has_many :teams
  has_many :nodes
  has_many :runners, :through => :teams

  before_create :create_teams

  attr_accessor :number_of_teams
  attr_accessor :auto_assign_runners
  
  default_value_for :creator_id, 1
  default_value_for :number_of_teams, 2
  default_value_for :auto_assign_runners, true

  TEAM_NAMES = ['red', 'blue', 'green', 'yellow', 'purple', 'black', 'white']

  scope :unstarted_games, where(['start_time IS NULL OR start_time < ?', Time.now])
  
  def code_already_used?(code)
    self.captures.any?{|cap| cap.node.codes.any?{|c| c.contents == code.contents}}
  end

  # update each team's time after a capture is created
  def current_aggregate_times
    # get all nodes for current game
    nodes = self.nodes
    
    # last_capture = Game.find(self.id).captures.last
    # set update reference time to last capture
    current_time = Time.now #last_capture.created_at #self.captures.last.created_at
    
    team_hash = {} # {1 => 300(s), 2 => 0(s), ...}
    # populating the hash
    self.teams.each{|team| team_hash[team.id] = team.aggregate_time }
    
    # for each node, 
    nodes.each do |node|
      previous_capture = self.captures[-2]
      # if there's a second to last capture
      if previous_capture
        team_id = previous_capture.team.id
        # compute (current_time - Capture.last.created_at)
        time_to_add = current_time - previous_capture.created_at  
        # update the aggregate time
        team_hash[team_id] += time_to_add
        # save the record
        # team.save
      end
    end
    
    team_hash
  end
  
  def update_aggregate_times!
    times_hash = self.current_aggregate_times
    times_hash.each do |team_id, new_time|
      team = Team.find(team_id)
      team.aggregate_time = new_time
      team.save!
    end
  end
  
  # # AFCHECK check my work
  # # Aggregate time for views
  # def current_aggregate_times
  #   # look through all nodes
  #   nodes = self.nodes
  #   # get current time
  #   current_time = Time.now
  #   # for each node, 
  #   nodes.each do |node|
  #     # get the second to last capure
  #     previous_capture = self.captures[-2]
  #     # if there's a second to last capture
  #     if previous_capture
  #       # set team to the previous owner
  #       team = previous_capture.team
  #       # compute (current_time - Capture.last.created_at)
  #       time_to_add = current_time - previous_capture.created_at  
  #       # update the agg time
  #       team.aggregate_time += time_to_add
  #     end
  #   end 
  # end
  
  def start!
    # TODO launch cron job?
    self.start_time = Time.now
    self.save!
    # queue the background job
    self.delay.end_after_delay   
  end
  
  # schedule end game routine using delayed_job
  def end_after_delay
    # this surrenders Thread execution, so Heroku might charge less, 
    # time limit is in minutes (so we multiply by 60)
    sleep self.time_limit * 60  
    self.end!
  end

  # end game routine
  def end!
    self.abort!
    
    # message all runners that the game is over
    outgoing_message = "The game is over. #{self.winning_team} has won."
    self.runners.each do |runner|
      Messaging.outgoing_sms(runner, outgoing_message)
    end
  end
  
  def abort!
    self.end_time = Time.now
    self.save!
    self.reset_nodes
    puts "The game has ended at + #{self.end_time}"
  end

  # before creating a new game check to see if one is currently in progress
  def check_for_active_game
    # TODO
  end

  #reset ownership of all nodes after the game is created
  # TODO
  def reset_nodes
    # get all nodes for the active game
    # reset ownership for all nodes
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

  # using the TEAM_NAMES array, create teams for the game
  def create_teams
    number_of_teams.to_i.times do |i|
      self.teams << Team.create(:name => TEAM_NAMES[i])
    end
  end

  # returns a hash of teams and total times
  # this method is deprecated
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

  def add_cluster(cluster)
    cluster.nodes.each do |node|
      nodes << node
    end
  end

  def expected_end_time
    self.start_time + self.time_limit.minutes if self.start_time and self.time_limit
  end

  # check to see if the game is active
  def has_ended?
    !self.end_time.blank? and Time.now > self.end_time
  end
  
  def has_started?
    !self.start_time.blank? and Time.now > self.start_time
  end
  
  def is_active?
    self.has_started? and !self.has_ended?
  end

  # return the team with the least Runners
  def smallest_team
    self.teams.min{|t1,t2| t1.runners.size <=> t2.runners.size }
  end

  # return the active game
  def self.active_game
    games = Game.all(:order => "created_at DESC")
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
