Given /^I create a new game$/ do
  @game = Game.create
end

Given /^I have a Cluster with Nodes$/ do
  @cluster = Cluster.create
  @nodes = [Node.create, Node.create]
  @cluster.nodes << @nodes
end

When /^I add a cluster to that game$/ do
  @game.add_cluster @cluster
end

Then /^all the nodes in that cluster should be added to the game$/ do
  assert @game.nodes == @cluster.nodes
  assert @game.nodes == @nodes
end

Given /^there are two Teams with Runners in the Game$/ do
  @team1 = Team.create
  @team2 = Team.create
  @runner1 = Runner.create
  @runner2 = Runner.create
  @team1.runners << @runner1
  @team2.runners << @runner2
  @game.teams << @team1
  @game.teams << @team2
end

When /^I request all the Runners in a Game$/ do
  @runners = @game.runners
end

Then /^I should see all the Runners$/ do
  assert @runners.include? @runner1
  assert @runners.include? @runner2 
end

