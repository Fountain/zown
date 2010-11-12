class Cluster < ActiveRecord::Base
  has_and_belongs_to_many :nodes
  
  #validates_uniqueness_of :nodes
  
#   def node_ids=(ids)
#     ids.each do |node_id|
#       node = Node.find node_id
#       self.nodes << node
#     end
#   end
  end
