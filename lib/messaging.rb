module Messaging
  # Twilio authentication credentials
  ACCOUNT_SID = 'AC0d3d975efe62587e3d304fd2b5723816'
  ACCOUNT_TOKEN = 'd5fd375ea52d200c1ff288ff7126dab6'

  # version of the Twilio REST API to use
  API_VERSION = '2010-04-01'

  # base URL of this application
  BASE_URL = "http://zown.heroku.com/sms"

  # Outgoing Caller ID you have previously validated with Twilio
  CALLER_ID = '9176526928'
  
  
  def outgoing_sms(runner, outgoing_message)
    account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)
    params = {
      'From' => CALLER_ID,
      'To' => runner.mobile_number,
      'Body' => outgoing_message,
    }
    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/SMS/Messages",
    'POST', params)
    # resp.error! unless resp.kind_of? Net::HTTPSuccess
    puts "code: #{resp.code}\nbody: #{resp.body}"
  end
  
  module_function :outgoing_sms

end