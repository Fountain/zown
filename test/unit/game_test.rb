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
    team1_id = runner1.current_team.id
    team2_id = runner2.current_team.id
    game.start!
    
    times = game.current_aggregate_times
    assert_equal 0.seconds, times[team1_id]
    assert_equal 0.seconds, times[team2_id]
    
    runner1.capture node
    
    times = game.reload.current_aggregate_times
    assert_in_delta 0.seconds, times[team1_id], 1.second
    assert_equal 0.seconds, times[team2_id]
    
    Timecop.travel(Time.now + 1.minute)
    
    times = game.current_aggregate_times
    assert_in_delta 1.minute, times[team1_id], 1.second
    assert_equal 0.seconds, times[team2_id]
    
    runner2.capture node
    
    times = game.reload.current_aggregate_times
    assert_in_delta 1.minute, times[team1_id], 1.second
    assert_in_delta 0.seconds, times[team2_id], 1.second
    
    Timecop.travel(Time.now + 1.minutes)
    
    times = game.reload.current_aggregate_times
    assert_in_delta 1.minute, times[team1_id], 1.second
    assert_in_delta 1.minute, times[team2_id], 1.second
    
    runner1.capture node
    
    times = game.reload.current_aggregate_times
    assert_in_delta 1.minute, times[team1_id], 1.second
    assert_in_delta 1.minute, times[team2_id], 1.second
    
    Timecop.travel(Time.now + 2.minutes)

    times = game.current_aggregate_times
    assert_in_delta 3.minute, times[team1_id], 1.second
    assert_in_delta 1.minutes, times[team2_id], 1.second
  end
  
  test "it should show correct winner" do
    game = Game.create!
    node = Node.create! :game => game
    runner1 = Runner.create! :mobile_number => '1234567890'
    runner1.join_game_auto_assign_team!
    runner2 = Runner.create! :mobile_number => '1234567899'
    runner2.join_game_auto_assign_team!
    game.start!
    
    runner1.capture node
    Timecop.travel(Time.now + 1.minute)
    runner2.capture node
    Timecop.travel(Time.now + 2.minutes)
    runner1.capture node
    game.abort!
    
    game.reload

    assert_equal runner2.current_team.id, game.winning_team
  end
end
