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

Given /^I am an unknown user$/ do
  @mobile_numer = "+12223334444"
  Runner.where(:mobile_number => @mobile_number).exists?.should be_false
end

When %r{^I sms "([^"]*)"$} do |message|
  VCR.use_cassette("unknown_user") do
    post '/api/twilio/sms', :From => @mobile_number, :Body => message
  end
end

Then /^I am added as a Runner$/ do
  Runner.where(:mobile_number => @mobile_number).exists?.should be_true
end

Given /^I am a Runner$/ do
  @runner = Runner.create!
end

Given /^there is an unstarted game available$/ do
  @game = Game.create!
end

When %r{^I request to "([^"]*)" a game$} do |arg1|
  pending # express the regexp above with the code you wish you had
end

#AF_CHECK
Then /^I am added to the game$/ do
  @game.runner?.should be_true
end

#AF_CHECK
Given /^there is no game available$/ do
  Games.
end

Then /^I am told there is no game available a this time$/ do
  pending # express the regexp above with the code you wish you had
end

When %r{^I message the system "([^"]*)", "([^"]*)", or "([^"]*)"$} do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Then /^I am unsubscribed from the system$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^there is an active game$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am a Runner in that game$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I submit a valid code$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^then my team controls that node$/ do
  pending # express the regexp above with the code you wish you had
end

When %r{^I request "([^"]*)"$} do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I receive stats for my current or previous game$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am a runner in that game$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I receive a list of Nodes available for capture$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am assigned to an active game$/ do
  pending # express the regexp above with the code you wish you had
end

Given %r{^that game's teams are not auto\-assigned$} do
  pending # express the regexp above with the code you wish you had
end

When %r{^I request to "([^"]*)"$} do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I am assigned to team red$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I belong to a team$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^the game I belong to has not begun$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I am added switched to the other team$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am a Captain$/ do
  #TODO Check that user is a captain
  @captain = Runner.new
  @captain.mobile_number = "+19174537966"
  @captain.save!
end

Then /^an inactive game exists$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^there is an inactive game$/ do
  @game = Game.create!
  @game.is_active?.should == false
end

When /^I start the game manually$/ do
  @game.start!
end

Then /^the game should be active$/ do
  @game.is_active?.should == true
end

When /^I repeat the last game$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^a new game is created with the same settings as the last game$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I abort my current game$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the game is aborted$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I end my current game$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the game is ended$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I balance teams$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the teams are balanced$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am a captain$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I create a new Node$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^a new code set is assigned to that Node$/ do
  pending # express the regexp above with the code you wish you had
end