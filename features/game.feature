Feature: Game
	Scenario: Associating Nodes with Games via cluster
		Given I create a new game
		And I have a Cluster with Nodes
		When I add a cluster to that game
		Then all the nodes in that cluster should be added to the game
		
	Scenario: Getting all the Runners in the Game
		Given I create a new game
		And there are two Teams with Runners in the Game
		When I request all the Runners in a Game
		Then I should see all the Runners
		
	Scenario: Automated game ending
		Given I create a new game
		And the time limit is 30 minutes
		When the game is started
		Then the game should end in 30 minutes

#####################
# Runner Scenarios #
###################
		
	Scenario: Unknown user messages the app
		Given There are no Runners
		And I have a mobile number of +19174537966
		When I sms "join" from +19174537966
		Then I am added as a Runner
		
	Scenario: Runner requests to join an unstarted game
		Given I am a Runner with mobile number +19174537966
		And there is an unstarted game available
		When I sms "join" from +19174537966
		Then I am added to the game

	Scenario: Runner requests to join an active game
		Given I am a Runner with mobile number +19174537966
		And there is an active game available
		When I sms "join" from +19174537966
		Then I am not added to the game
		
	Scenario: Runner requests to join a game and no game is available
		Given I am a Runner
		And there are no unstarted games
		When I request to "join" a game
		Then I am told there is no game available at this time
	
	Scenario: Unsubscribing from the system using unsubscribe
		Given I am a Runner
		When I sms "unsubscribe" from +19174537966
		Then I am unsubscribed from the system
		
	Scenario: Unsubscribing from the system using unsub
		Given I am a Runner
		When I sms "unsub" from +19174537966
		Then I am unsubscribed from the system

	Scenario: Unsubscribing from the system using quit
		Given I am a Runner
		When I sms "quit" from +19174537966
		Then I am unsubscribed from the system
		
	Scenario: Capturing a Node
		Given I am a Runner
		And there is an active game
		And I am a Runner in that game
		When I submit a valid code
		Then then my team controls that node
	
	Scenario: Requesting stats
		Given I am a Runner
		When I request "stats"
		Then I receive stats for my current or previous game
	
	Scenario: Requesting free zowns
		Given I am a Runner
		And there is an active game
		And I am a runner in that game
		When I request "free"
		Then I receive a list of Nodes available for capture
		
	Scenario: Joining a team
		Given I am a Runner
		And I am assigned to an active game
		And that game's teams are not auto-assigned
		When I request to "join team red"
		Then I am assigned to team red
		
	Scenario: Switching Teams
		Given I am a Runner
		And there is an active game
		And I belong to the "red" team
		And the game I belong to has not begun
		When I request to "switch"
		Then I am switched to the other team	

######################
# Captain Scenarios #
####################

	Scenario: Creating a new game
		Given I am a captain
		When I create a new game
		Then an unstarted game exists
		
	Scenario: Teams should get names automatically
		Given I am a captain
		When I create a new game
		Then that games teams should have names
			
	Scenario: Manually starting a game
		Given I am a captain
		And there is an unstarted game
		When I start the game manually
		Then the game should be active
		
	Scenario: Repeating the last game
		Given I am a captain
		When I repeat the last game
		Then a new game is created with the same settings as the last game
		
	Scenario: Aborting a game
		Given I am a captain
		And there is an active game
		When I abort my current game
		Then there are no active games
		
	Scenario: Ending a game
		Given I am a captain
		And there is an active game
		When I end my current game
		Then the game is ended
	
	Scenario Outline: Balancing Two Teams	
		Given I am a captain
		And there is an active game
		And there are two teams
		And the red team has <red_start_count> runners
		And the blue team has <blue_start_count> runners
		When I balance teams
		Then <expected_message_count> messages should have been sent
		
		Examples:
			| red_start_count | blue_start_count | expected_message_count |
			| 2	| 2 | 0 |
			| 2 | 3 | 0 | 
			| 4 | 10 | 3 |
		
	Scenario Outline: Balancing Two Teams	
		Given I am a captain
		And there is an active game
		And there are two teams
		And the red team has <red_start_count> runners
		And the blue team has <blue_start_count> runners
		When I balance teams
		Then red team should have <red_end_count> runners
		And blue team should have <blue_end_count> runners
		
		Examples:
			| red_start_count | blue_start_count | red_end_count | blue_end_count |
			| 2	| 2 | 2 | 2 |
			| 2 | 3 | 2 | 3 |
			| 4 | 10 | 7 | 7 |
		
	Scenario: Create new Node
		Given I am a captain
		When I create a new Node
		Then a new code set is assigned to that Node		