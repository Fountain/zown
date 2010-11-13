Feature: Node

	Scenario: Calculate time between captures
		Given a node in an active game
		And team one captured that node at 
			| 1:00pm | 
		When team two captured that node at
			| 1:10pm |
		Then team one should have a cumulative time in minutes of
			| 10 |