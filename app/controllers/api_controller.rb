class ApiController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  # Twilio authentication credentials
  ACCOUNT_SID = 'AC0d3d975efe62587e3d304fd2b5723816'
  ACCOUNT_TOKEN = 'd5fd375ea52d200c1ff288ff7126dab6'

  # version of the Twilio REST API to use
  API_VERSION = '2010-04-01'

  # base URL of this application
  BASE_URL = "http://zown.heroku.com/sms"

  # Outgoing Caller ID you have previously validated with Twilio
  CALLER_ID = '9176526928'
  
  def twilio_sms
    runner = Runner.find_or_create_by_mobile_number params["From"]
    message = params["Body"].strip
    
    begin
      # stuff that might throw exceptions  
      if message =~ /^join$/i
        # join game and auto assign team
        runner.join_game_auto_assign_team
        runner.save
        sms_body = "Added to team" 
        twilio_sms_response(runner, message)
      elsif message =~ /^join (.+)$/i
        team_name = $1
        join_team(runner, team_name)
      elsif authenticate_code(runner, message)
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
        Capture.create(:node => node, :runner => runner, :game => game)
      else
        # send error 'I don't know that code'
        raise "I don't know that code"
      end
    else
    
    end
    
    true
  end
  
  
  def twilio_sms_response(runner, sms_body)
    account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)
    params = {
        'From' => CALLER_ID,
        'To' => runner,
        'Body' => sms_body,
    }
    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/SMS/Messages",
        'POST', params)
    # resp.error! unless resp.kind_of? Net::HTTPSuccess
    # render "code: %s\nbody: %s" % [resp.code, resp.body]
  end
    
end