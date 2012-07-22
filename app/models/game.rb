class Game < ActiveRecord::Base
  has_many :captures
  has_many :teams
  has_many :nodes

  before_create :create_teams

  attr_accessor :number_of_teams
  attr_accessor :auto_assign_runners
  
  default_value_for :creator_id, 1
  default_value_for :number_of_teams, 2
  default_value_for :auto_assign_runners, true

  TEAM_NAMES = ['red', 'blue', 'green', 'yellow', 'purple', 'black', 'white']

  scope :unstarted_games, where(['start_time IS NULL OR start_time < ?', Time.now])
  
  def code_already_used?(code)
    !self.captures.where(:code => code).empty?
  end
  
  # collect runners here instead of using association
  def runners
    self.teams.reduce([]){|runners, team| runners + (team.runners) }
  end

  # retrieve the running aggregate time for each team
  def current_aggregate_times
    # last_capture = Game.find(self.id).captures.last
    # set update reference time to last capture
    current_time = Time.now #last_capture.created_at #self.captures.last.created_at
    
    team_hash = {} # {1 => 300(s), 2 => 0(s), ...}
    # populating the hash
    self.teams.each{|team| team_hash[team] = team.aggregate_time }
    
    # for each node in current game
    self.nodes.each do |node|
      last_capture = node.last_capture
      if last_capture
        time_to_add = current_time - last_capture.created_at  
        # update the aggregate time
        team_hash[last_capture.team] += time_to_add
      end
    end
    
    team_hash
  end
  
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
      logger.debug "Game attributes hash: #{runner.mobile_number}" 
      Messaging.outgoing_sms(runner.mobile_number, outgoing_message)
    end
  end
  
  def abort!
    end_time = Time.now
    self.end_time = end_time
    self.save!
    
    self.current_aggregate_times.each do |team, time|
      team.aggregate_time = time
      team.save!
    end
    
    self.reset_nodes
    
    puts "The game has ended at + #{self.end_time}"
  end
  
  def balance_teams
    # get all team sizes
    teams = self.teams
    # keep balancing teams until all are balanced 
    begin
      team = teams.sort_by{|team| team.runners.size}
      average_runners_per_team = self.runners.size / self.teams.size.to_f
      target_number = average_runners_per_team.ceil
      smallest_team = teams.first
      biggest_team = teams.last
    
      if biggest_team.runners.size > target_number
        # move them from the largest team to the smallest team
        runner = biggest_team.runners.last
        smallest_team.runners << runner
        
        # send alert to affected Runners
        message = "You have been switched to #{runner.current_team.name} team."
        Messaging.outgoing_sms(runner.mobile_number, message)
      end
    end while biggest_team.runners.size > target_number
    
  end

  def repeat_game
    true
    # get last game
    # create a new game with same settings
  end
  
  # before creating a new game check to see if one is currently in progress
  def check_for_active_game
    # TODO
  end

  #reset ownership of all nodes after the game is created
  # TODO
  def reset_nodes
    # get all nodes for the active game
    self.nodes.update_all(:game_id => nil) 
    # reset ownership for all nodes
  end

  def winning_team
    # return the team with the max aggregate time
    self.current_aggregate_times.max{|a,b| a[1] <=> b[1]}[0]
  end

  # using the TEAM_NAMES array, create teams for the game
  def create_teams
    number_of_teams.to_i.times do |i|
      self.teams << Team.create!(:name => TEAM_NAMES[i])
    end
  end

  def add_cluster(cluster)
    cluster.nodes.each do |node|
      nodes << node
    end
  end

  def expected_end_time
    self.start_time + self.time_limit.minutes if self.start_time and self.time_limit
  end
    
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
  
  # are there any captures yet?
  def first_capture?
    self.captures.empty?
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
  
  def red_team
    self.team_by_color('red')
  end
  
  def blue_team
    self.team_by_color('blue')
  end
  
  def team_by_color(color)
    self.teams.find_by_name(color)
  end

end
