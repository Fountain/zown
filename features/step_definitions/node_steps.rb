Given /^a node in an active game$/ do
  @game = Game.create!
  @game.start!
  @node = Node.create!
  @runner1 = Runner.create!(:mobile_number => '+19174537966')
  @runner2 = Runner.create!(:mobile_number => '+12223335555')
  @game.teams[0].runners << @runner1
  @game.teams[1].runners << @runner2
  @runner1.save!
  @runner2.save!
  @game.nodes << @node
  @node.save!
end

Given /^team one captured that node at$/ do |table|
  # table is a Cucumber::Ast::Table
  table.raw.each do |row|
    time_str = row.first
    time = Time.parse(time_str)
    capture = Capture.new
      capture.game = @game
      capture.node = @node
      capture.runner = @runner1
      capture.created_at = time
      capture.team = @runner1.team
    capture.save!
  end
end

When /^team two captured that node at$/ do |table|
  # table is a Cucumber::Ast::Table
  table.raw.each do |row|
    time_str = row.first
    time = Time.parse(time_str)
    capture = Capture.new
      capture.game = @game
      capture.node = @node
      capture.runner = @runner2
      capture.created_at = time
      capture.team = @runner2.team
    capture.save!
  end
end

Then /^each team should have a runner$/ do
  Runner.all.size.should == 2
  @game.teams[0].runners.size.should == 1
  @game.teams[1].runners.size.should == 1
end

Then /^each runner should have a capture$/ do
  @runner1.captures.size.should == 1
  @runner2.captures.size.should == 1
end


Then /^each team should have a capture$/ do
  Capture.all.size.should == 2
  @game.teams[0].captures.size.should == 1
  @game.teams[1].captures.size.should == 1
end

Then /^team one should have a cumulative time in minutes of$/ do |table|
  # table is a Cucumber::Ast::Table
  table.raw.each do |row|
    times = @node.cumulative_time
    team1 = @game.teams[0]
    team1_time = times[team1]
    team1_time.should == row.first.to_i.minutes
  end
end