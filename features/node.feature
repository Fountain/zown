Feature: Node

	Scenario: Capturing a node
		Given a node in an active game
		And team one captured that node at 
			| 1:00pm | 
		When team two captured that node at
			| 1:10pm |
		Then each team should have a runner
		Then each runner should have a capture
		Then each team should have a capture
	
	Scenario: Calculate time between captures
		Given a node in an active game
		And team one captured that node at 
			| 1:00pm | 
		When team two captured that node at
			| 1:10pm |
		Then each team should have a runner
		Then each team should have a capture
		And team one should have a cumulative time in minutes of
			| 10 |