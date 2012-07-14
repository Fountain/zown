require 'test_helper'

class RunnerTest < ActiveSupport::TestCase
  test "it should auto-assign runners to different teams" do
    game = Game.create!
    runner1 = Runner.create! :mobile_number => '1234567890'
    runner1.join_game_auto_assign_team!
    runner2 = Runner.create! :mobile_number => '1234567899'
    runner2.join_game_auto_assign_team!
    
    assert_not_equal runner1.current_team, runner2.current_team
  end
end
