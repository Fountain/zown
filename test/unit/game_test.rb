require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "it should give correct aggregate times" do
    assert_equal 0, Capture.all.size
    game = Game.create!
    node = Node.create! :game => game
    runner1 = Runner.create! :mobile_number => '1234567890'
    runner1.join_game_auto_assign_team!
    runner2 = Runner.create! :mobile_number => '1234567899'
    runner2.join_game_auto_assign_team!
    team1 = runner1.current_team
    team2 = runner2.current_team
    game.start!
    
    times = game.current_aggregate_times
    assert_equal 0.seconds, times[team1]
    assert_equal 0.seconds, times[team2]
    
    runner1.capture node
    
    times = game.reload.current_aggregate_times
    assert_in_delta 0.seconds, times[team1], 1.second
    assert_equal 0.seconds, times[team2]
    
    Timecop.travel(Time.now + 1.minute)
    
    times = game.current_aggregate_times
    assert_in_delta 1.minute, times[team1], 1.second
    assert_equal 0.seconds, times[team2]
    
    runner2.capture node
    
    times = game.reload.current_aggregate_times
    assert_in_delta 1.minute, times[team1], 1.second
    assert_in_delta 0.seconds, times[team2], 1.second
    
    Timecop.travel(Time.now + 1.minutes)
    
    times = game.reload.current_aggregate_times
    assert_in_delta 1.minute, times[team1], 1.second
    assert_in_delta 1.minute, times[team2], 1.second
    
    runner1.capture node
    
    times = game.reload.current_aggregate_times
    assert_in_delta 1.minute, times[team1], 1.second
    assert_in_delta 1.minute, times[team2], 1.second
    
    Timecop.travel(Time.now + 2.minutes)

    times = game.current_aggregate_times
    assert_in_delta 3.minute, times[team1], 1.second
    assert_in_delta 1.minutes, times[team2], 1.second
  end
  
  test "it should show correct winner" do
    game = Game.create!
    node = Node.create! :game => game
    runner1 = Runner.create! :mobile_number => '1234567890'
    runner1.join_game_auto_assign_team!
    runner2 = Runner.create! :mobile_number => '1234567899'
    runner2.join_game_auto_assign_team!
    team2 = runner2.current_team
    game.start!
    
    runner1.capture node
    Timecop.travel(Time.now + 1.minute)
    runner2.capture node
    Timecop.travel(Time.now + 2.minutes)
    runner1.capture node
    game.reload
    game.abort!

    assert_equal team2, game.winning_team
  end
  
  test "it should ignore previous games" do
    game1 = Game.create!
    node = Node.create! :game => game1
    runner1 = Runner.create! :mobile_number => '1234567890'
    runner1.join_game_auto_assign_team!
    runner2 = Runner.create! :mobile_number => '1234567899'
    runner2.join_game_auto_assign_team!
    game1.start!
    
    runner1.capture node
    Timecop.travel(Time.now + 3.minutes)
    game1.abort!
    
    game1.reload
    assert_equal runner1.current_team, game1.winning_team
    
    game2 = Game.create!
    node.game = game2
    node.save!
    
    assert node.current_game_captures.empty?

    runner1.join_game_auto_assign_team!
    team1 = runner1.current_team
    assert_equal 0.seconds, team1.aggregate_time
    assert team1.captures.empty?

    runner2.join_game_auto_assign_team!
    team2 = runner2.current_team
    assert_equal 0.seconds, team2.aggregate_time
    assert team2.captures.empty?
    
    game2.start!
    
    runner2.capture node
    game2.reload
    Timecop.travel(Time.now + 1.minute)
    game2.abort!
    
    assert_equal runner2.current_team, game2.winning_team
  end
  
  test "ending the game should update the aggregate time for the team" do
    game = Game.create!
    node = Node.create! :game => game
    runner1 = Runner.create! :mobile_number => '1234567890'
    runner1.join_game_auto_assign_team!
    runner2 = Runner.create! :mobile_number => '1234567899'
    runner2.join_game_auto_assign_team!
    team2 = runner2.current_team
    game.start!
    
    runner2.capture node
    game.reload
    Timecop.travel(Time.now + 1.minute)
    game.abort!
    
    team2.reload
    assert_in_delta 1.minute, team2.aggregate_time, 1.second
  end
end
