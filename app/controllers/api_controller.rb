class ApiController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  

  
  def twilio_sms
    runner = Runner.find_or_create_by_mobile_number params["From"]
    message = params["Body"].strip
    
    begin
      # stuff that might throw exceptions  
      if message =~ /^join$/i
        # join game and auto assign team
        runner.join_game_auto_assign_team
        runner.save
        outgoing_message = "Added to #{runner.team}" 
        Messaging.outgoing_sms(runner, outgoing_message)
      elsif message =~ /^join (.+)$/i
        team_name = $1
        join_team(runner, team_name)
      elsif authenticate_code(runner, message)
        outgoing_message = "zown successfully captured"
        Messaging.outgoing_sms(runner, outgoing_message)
      else
       # send error message
      end
    rescue => e
      # do stuff with excpetions
      # send_message(e.to_s)
    end
    render :text => 'OK!'
  end
  
  def join_team(runner, team_name)
    team = Team.find_by_name(team_name.downcase)
    if team
      runner.team = team
      runner.save
    else
      raise 'team not found'
    end
  end
  
  # authenticate capture
  def authenticate_code(runner, message)
    # if code is not in active game
    code = Code.find_by_contents(message.upcase)
    if code
      node = code.node
      game = node.game
      if game.is_active?
        # if code has been used
        # send error 'aleady used'
        # if code is good, create code
        # TODO abstract to Runner class (take a code as argument)
        Capture.create(:node => node, :runner => runner, :game => game, :team => runner.team)
        
      else
        # send error 'I don't know that code'
        raise "I don't know that code"
      end
    else
    
    end
    
    true
  end
    
end