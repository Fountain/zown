class Node < ActiveRecord::Base
  has_many :captures
  has_and_belongs_to_many :clusters
  belongs_to :game
  has_many :codes, :dependent => :destroy
  
  after_create :assign_codes
  
  CODE_COUNT = 128
  
  # get the cumulative time for node
  # TODO add temporary capture at end for measuring purposes
  def cumulative_time
    # get all captures with in the current game 
    captures = self.captures.where :game_id => self.game.id
    # create a time holder for each team
    times = {}
    self.game.teams.each {|team| times[team] = 0 }
    # go through each capture
    last_capture = nil
    captures.each_with_index do |capture, i| 
      # unless this is the first time this node has been captured
      unless last_capture.nil?        
        # find the difference between the current capture and the last
        diff = capture.created_at - last_capture.created_at
        # add that difference to the previous owner's cumulative time
        team = last_capture.team
        times[team] += diff
      end
      last_capture = capture
    end
    # return the total for the requested team
    times
  end
  
  def self.find_by_code(contents)
    code = Code.find_by_contents(contents)
    code.node if code
  end
  
  def assign_codes
    codes = Node.generate_alphanumeric_code_set
    codes.each do |code|
      Code.create :contents => code, :node => self
    end
  end
  
  #generate numbers only code set
  def self.generate_code_set(count=CODE_COUNT, seed=nil)
    if seed
      srand seed
    end
    
    # create a blank array to hold codes
    numbers = []
    # genearate codes
    count.times do |i|
      num = rand(9999)
      # confirm number is unique
      while numbers.include?(num)
        num = rand 9999
      end
      # now our number is new
      
      num_str = num.to_s
      # check that number is four digits
      while num_str.length < 4
        num_str = "0" + num_str
      end
      # add to array
      numbers << num_str
    end
    numbers
  end
  
  #generate an Alphanumeric code set
  def self.generate_alphanumeric_code_set(count=CODE_COUNT, seed=nil)
     if seed
       srand seed
     end

     size = 4
     chars = ('A'..'Z').to_a + ('0'..'9').to_a
     
     # create a blank array to hold codes
     numbers = []
     # genearate codes
     count.times do |i|
       num = (0...size).collect { chars[Kernel.rand(chars.length)] }.join
       # confirm number is unique
       while numbers.include?(num)
         num = (0...size).collect { chars[Kernel.rand(chars.length)] }.join
       end
       # now our number is new
       numbers << num
     end
     numbers
   end
  
  def current_owner
    capture = self.captures.order("created_at").last 
    capture.team if capture
  end
end