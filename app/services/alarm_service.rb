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
    client.push_message('C509a0f264fe54b6957e97e53251ae409', message)
  end

  def ptt(kanban)
    service = PttService.new(kanban)
    message = {
      type: "text",
      text: service.ptt
    }
    client.push_message('C509a0f264fe54b6957e97e53251ae409', message)
  end

  def ptt_Lai(kanban)
    service = PttService.new(kanban)
    message = {
      type: "text",
      text: service.ptt
    }
    client.push_message('U2584df52f0d763c2ed68aea140533e0b', message)
  end

  def happy
    message = {
      type: "text",
      text: "小弟9527在此搶個頭香" + "\n" + "恭賀娘娘二十六歲誕辰紀念日" + "\n" + "祝賀娘娘福如東海，壽比南山"
    }
    client.push_message('U2584df52f0d763c2ed68aea140533e0b', message)
  end

end