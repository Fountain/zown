class Node < ActiveRecord::Base
  has_many :captures
  has_and_belongs_to_many :clusters
  belongs_to :game
  has_many :codes, :dependent => :destroy
  
  after_create :assign_codes
  
  CODE_COUNT = 100
  
  def self.find_by_code(contents)
    code = Code.find_by_contents(contents)
    code.node if code
  end
  
  def assign_codes
    codes = Node.generate_code_set
    codes.each do |code|
      Code.create :contents => code, :node => self
    end
  end
  
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
end