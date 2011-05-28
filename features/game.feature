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
		And there is no game available
		When I request to "join" a game
		Then I am told there is no game available at this time
	
	Scenario: Unsubscribing from the system
		Given I am a Runner
		When I message the system "unsubscribe", "unsub", or "quit"
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
		And I belong to a team
		And the game I belong to has not begun
		When I request to "switch"
		Then I am added switched to the other team	

######################
# Captain Scenarios #
####################

	Scenario: Creating a new game
		Given I am a captain
		When I create a new game
		Then an unstarted game exists
		
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
		And there is a game in progress
		When I abort my current game
		Then the game is aborted
		
	Scenario: Ending a game
		Given I am a captain
		And there is an active game
		When I end my current game
		Then the game is ended
		
	Scenario: Balancing Teams
		Given I am a captain
		When I balance teams
		Then the teams are balanced
		
	Scenario: Create new Node
		Given I am a captain
		When I create a new Node
		Then a new code set is assigned to that Node		