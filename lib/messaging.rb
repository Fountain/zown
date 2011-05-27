module Messaging
  # Twilio authentication credentials
  ACCOUNT_SID = 'AC0d3d975efe62587e3d304fd2b5723816'
  ACCOUNT_TOKEN = ENV['ZOWN_TWILIO_SECRET'] || raise("Please set Twlio Secret")

  # version of the Twilio REST API to use
  API_VERSION = '2010-04-01'

  # base URL of this application
  BASE_URL = ENV['ZOWN_TWILIO_SMS_URL'] || raise("Please set Twilio SMS URL")

  # Outgoing Caller ID you have previously validated with Twilio
  CALLER_ID = ENV['ZOWN_TWILIO_MOBILE_NUMBER'] || raise("Please set Twlio Mobile Number")
  
  
  def outgoing_sms(mobile_number, outgoing_message)
    account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)
    params = {
      'From' => CALLER_ID,
      'To' => mobile_number,
      'Body' => outgoing_message,
    }
    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/SMS/Messages",
    'POST', params)
    # resp.error! unless resp.kind_of? Net::HTTPSuccess
    puts "code: #{resp.code}\nbody: #{resp.body}"
  end
  
  module_function :outgoing_sms

end