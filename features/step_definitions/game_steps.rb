Given /^I create a new game$/ do
  @game = Game.create!
end

Given /^I have a Cluster with Nodes$/ do
  @cluster = Cluster.create!
  @nodes = [Node.create!, Node.create!]
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
  @team1 = Team.create!
  @team2 = Team.create!
  @runner1 = Runner.create!(:mobile_number => '+19174537966')
  @runner2 = Runner.create!(:mobile_number => '+12223335555')
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
  @mobile_numer = "+19174537966"
  Runner.where(:mobile_number => @mobile_number).exists?.should be_false
end

Given /^I have a mobile number of (\+\d+)$/ do |mobile_number|
  @mobile_number = mobile_number
end

When %r{^I sms "([^"]*)" from (\+\d+)$} do |message, mobile_number|
  mobile_number.should_not == nil
  VCR.use_cassette("twilio") do
    post '/api/twilio/sms', :From => mobile_number, :Body => message
  end
end

Then /^I am added as a Runner$/ do
  Runner.where(:mobile_number => @mobile_number).exists?.should be_true
end

Given /^I am a Runner$/ do
  @mobile_number = "+12223335555"
  @runner = Runner.create!(:mobile_number => @mobile_number) 
end

Given /^there is an unstarted game available$/ do
  @game = Game.create!
end

Given /^there is an active game available$/ do
  @game = Game.create!
  @game.start!
end

When %r{^I request to "([^"]*)" a game$} do |message|
  VCR.use_cassette("twilio") do
    post '/api/twilio/sms', :From => @mobile_number, :Body => message
  end
end

Then /^I am added to the game$/ do
  @game.should_not be_nil
  @runner.should_not be_nil
  @game.runners.include?(@runner).should be_true
end

Then /^I am not added to the game$/ do
  @game.should_not be_nil
  @runner.should_not be_nil
  @game.runners.include?(@runner).should be_false
end

Given /^there are no unstarted games$/ do
  Game.unstarted_games.should be_empty
end

Given /^there is no game available$/ do
  Game.all.size.should == 0
end

Then /^I am told there is no game available at this time$/ do
  WebMock.should have_requested(:post, /twilio\.com/).with(:body => /There%20are%20no%20active%20games/).once
end

Then /^I am unsubscribed from the system$/ do
  pending
  Runner.where(:mobile_number => @mobile_number).exists?.should be_false
end

Given /^there is an active game$/ do
  @game = Game.create!
  @game.start!
  @game.is_active?.should == true
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

Given /^I belong to the "(\w+)" team$/ do |team_name|
  pending
  teams = Game.active_game.teams
  teams.should_not be_empty
  team = teams.where(:name => team_name)
  team = should_not be_nil
  @runner.team = team
  @runner.save!
end

Given /^the game I belong to has not begun$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^that games teams should have names$/ do
  @game.teams.size.should == 2
  @game.teams[0].name.should == 'red'
  @game.teams[1].name.should == 'blue'
end

Then /^I am switched to the other team$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am a captain$/ do
  #TODO Check that user is a captain
  @captain = Runner.new
  @captain.mobile_number = "+19174537966"
  @captain.save!
end

Then /^an unstarted game exists$/ do
  @game = Game.unstarted_games.first
  @game.is_active?.should be_false
  @game.has_started?.should be_false
end

Given /^there is an unstarted game$/ do
  @game = Game.create!
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
  @game.abort!
end

Then /^there are no active games$/ do
  Game.active_game.should be_nil
end

When /^I end my current game$/ do
  Game.active_game.end!
end

Then /^the game is ended$/ do
  Game.last.has_ended?.should be_true
end

When /^I balance teams$/ do
  stub_request(:post, /twilio\.com/)
  Game.active_game.balance_teams
end

Then /^the teams are balanced$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I create a new Node$/ do
  @node = Node.create!
end

Then /^a new code set is assigned to that Node$/ do
  node_size = Node::CODE_COUNT
  @node.codes.size.should == node_size
end

Given /^there is a game in progress$/ do
  @game = Game.create!
  @game.start!
end

Given /^There are no Runners$/ do
  Runner.all.size.should == 0
end

Given /^I am a Runner with mobile number (\+\d+)$/ do |mobile_number|
  @runner = Runner.create!(:mobile_number => mobile_number)
end

Given /^the time limit is (\d+) minutes$/ do |time_limit|
  @game.time_limit = time_limit
  @game.save!
end

When /^the game is started$/ do
  Game.unstarted_games.first.start!
end

Then /^the game should end in (\d+) minutes$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^there are two teams$/ do
  while @game.teams.size < 2
    team = Team.create!
    @game.teams << team
  end
end

Given /^the (\w+) team has (\d+) runners$/ do |color, desired_runners|
  team = @game.team_by_color(color)
  while team.runners.size < desired_runners.to_i
    runner = Runner.create! (:mobile_number => Factory.next(:mobile_number))
    team.runners << runner
  end
end

Then /^(\w+) team should have (\d+) runners$/ do |color, expected_runners|
  team = @game.team_by_color(color)
  team.runners.size.should == expected_runners.to_i
end

Then /^(\d+) messages should have been sent$/ do |expected_message_count|
  a_request(:post, /twilio\.com/).should have_been_made.times(expected_message_count)
end


