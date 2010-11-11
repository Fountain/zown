class Code < ActiveRecord::Base
  belongs_to :node
  
  validates_presence_of :contents, :node_id
end
