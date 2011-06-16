Feature: Runner
	Scenario: Current team
		Given there is an active game with runners:
			| mobile_number | team |
			| +12223334444 | blue |
		Then current team of +12223334444 should be blue
