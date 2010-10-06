class CreateClustersNodesJoin < ActiveRecord::Migration
  def self.up
    create_table :clusters_nodes, :id => false do |t|
      t.integer :node_id
      t.integer :cluster_id
    end
  end

  def self.down
    drop_table :clusters_nodes
  end
end
