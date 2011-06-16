Then /^current team of (\+\d+) should be blue$/ do |mobile_number|
  runner = Runner.find_by_mobile_number(mobile_number)
  runner.current_team.name.should == 'blue'
end
