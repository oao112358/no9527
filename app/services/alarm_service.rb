require 'line/bot'

class AlarmService
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = 'c9f30185a7af92e0dce842c150ad6691'
			config.channel_token = 'cCfGNO6m2Z23Qah7sj3Aybq2eT9C1v8dH9YNrgPnVXd83y86IZorofx9Rs45eIe8qRS3AjMJFw3oQyq6iDxK1bxLiDuOp3Klk7A2O9cSslrsvxTlKM0bu55gshHB/6EVHUHtyuwqyv8Nel0Th5QOTAdB04t89/1O/w1cDnyilFU='
    end
  end

  def run
    message = {
      type: "text",
      text: "現在時間：#{Time.current} 趕快起床吧"
    }
    client.push_message('U06b94675c0efcc90bebb6ac357107c4e', message)
  end
end