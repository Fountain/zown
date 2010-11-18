class ApiController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  def twilio_sms
    runner = Runner.find_or_create_by_mobile_number params["From"]
    message = params["Body"].strip
    
    begin
      # stuff that might throw exceptions  
      if message == "join"
        # join game and auto assign team
        runner.join_game_auto_assign_team
        runner.save
      elsif message =~ /^join (.+)$/i
        team_name = $1
        join_team(runner, team_name)
      elsif Code.exists?(:contents => message)
        authenticate_code(runner, message)
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
    team = Team.find_by_name(team_name)
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
    code = Code.find_by_contents(message)
    node = code.node
    game = node.game
    if game.is_active?
      # if code has been used
      # send error 'aleady used'
      # if code is good, create code
      Capture.create(:node => node, :runner => runner, :game => game)
    else
      # send error 'I don't know that code'
      raise "I don't know that code"
    end
  end
end