Given /^a node in an active game$/ do
  @game = Game.create
  @node = Node.create
  @runner1 = Runner.create
  @runner2 = Runner.create
  @game.teams[0].runners << @runner1
  @game.teams[1].runners << @runner2
  @game.nodes << @node
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
    capture.save!
  end
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