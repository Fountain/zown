class ApiController < ApplicationController
  
  skip_before_filter :verify_authenticity_token 
  
  def message
    # @runners = ..
    # @teams = 
  end
  
  def submit_message
    message = params[:message]
    mobile_number = params[:mobile_number]
    
    #do stuff
    outgoing_message = parse_sms(message, mobile_number)    
    redirect_to message_path, :notice => outgoing_message
  end
  
  def twilio_sms
    mobile_number = params["From"]
    message = params["Body"]
    # send to parser and get response
    outgoing_message = parse_sms(message, mobile_number)
    unless outgoing_message.blank?
      # send response
      Messaging.outgoing_sms(mobile_number, outgoing_message)
      render :text => outgoing_message
    end
  end
  
  # returns a message or nil
  def parse_sms(message, mobile_number)
    runner = Runner.find_by_mobile_number(mobile_number)
    outgoing_message = ""
    if runner.nil?
      runner = Runner.new
      runner.mobile_number = mobile_number
      runner.save!
      outgoing_message += "Hello runner. You've been added to the system. "
    end

    if Game.active_game
      message.strip!
      begin
        # stuff that might throw exceptions  
        if message =~ /^join$/i
          # join game and auto assign team
          runner.join_game_auto_assign_team!
          outgoing_message += "Added to #{runner.team.to_s}"  
        elsif message =~ /^join (.+)$/i
          team_name = $1
          runner.join_team!(team_name)
          outgoing_message = "Joined #{runner.team.to_s}"
        elsif authenticate_code(runner, message)
          # successfully captured
          outgoing_message += "zown succesfully captured" 
        else
         outgoing_message += "message unclear, try again"
        end
      rescue RuntimeError => e
        # do stuff with excpetions
        outgoing_message = e.to_s
      end
    else
      outgoing_message += "There are no active games. Hang tight."
    end
    outgoing_message
  end
  
  # authenticate capture
  def authenticate_code(runner, message)
    # if code is not in active game
    code = Code.find_by_contents(message.upcase)
    if code
      node = code.node
      game = node.game
      if game.code_already_used?(code)
        raise "code already used"
      end
      # if code is good, create code
      # TODO abstract to Runner class (take a code as argument)
      capture = Capture.new(:node => node, :runner => runner, :game => game, :team => runner.team)
      if capture.save
        # returns true        
      else
        # send message
        raise "zown could not be captured: " + capture.errors.full_messages.join("; ")
      end
    else
      raise "code not found"
    end    
    true
  end
  

  
end