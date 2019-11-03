require 'line/bot'
require 'nokogiri'

class No9527Controller < ApplicationController
	protect_from_forgery with: :null_session

	def eat
		render plain: "工號9527餵您吃飯!"
	end
	
	def request_headers
		# render plain: request.headers.to_h.keys.sort.join("\n")
		render plain: request.headers.to_h.reject{ |key, value| 
			key.include? '.'
		}.map{ |key, value|
			"#{key}: #{value}"
		}.sort.join("\n")
	end
		
	def request_body
		render plain: request.body
	end
	
	def response_headers
		response.headers['9527'] = 'QQ'
		render plain: response.headers.to_h.map { |key, value|
			"#{key}: #{value}"
		}.sort.join("\n")
	end

	def show_response_body
		puts "9527躲在這兒A____A"
		render plain: response.body
	end

	def sent_request
		uri = URI('http://localhost:3000/no9527/response_body')
		response = Net::HTTP.get(uri)
		render plain: response
	end



	def webhook
		# 設定回覆文字
    reply_text = keyword_reply(received_text)
	
		# 傳送訊息
		response = reply_to_line(reply_text)
			
		# 回應 200
		head :ok
	end

	# Line Bot API 物件初始化
	def line
		return @line unless @line.nil?
		@line = Line::Bot::Client.new { |config|
			config.channel_secret = 'c9f30185a7af92e0dce842c150ad6691'
			config.channel_token = 'cCfGNO6m2Z23Qah7sj3Aybq2eT9C1v8dH9YNrgPnVXd83y86IZorofx9Rs45eIe8qRS3AjMJFw3oQyq6iDxK1bxLiDuOp3Klk7A2O9cSslrsvxTlKM0bu55gshHB/6EVHUHtyuwqyv8Nel0Th5QOTAdB04t89/1O/w1cDnyilFU='
		}
	end

	# 傳送訊息到 line
	def reply_to_line(reply_text)
		return nil if reply_text.nil?
		
		# 取得 reply token
		reply_token = params['events'][0]['replyToken']
		
		# 設定回覆訊息
		message = {
			type: 'text',
			text: 'reply_text'
		}

		# 傳送訊息
		line.reply_message(reply_token, message)
  end

	# 取得對方說的話
	def received_text
		message = params['events'][0]['message']
    message['text'] unless message.nil?
	end

	# 關鍵字回覆
	def keyword_reply(received_text)
		# 學習紀錄表
    keyword_mapping = {
      'QQ' => '神曲支援：https://www.youtube.com/watch?v=T0LfHEwEXXw&feature=youtu.be&t=1m13s',
      '我難過' => '神曲支援：https://www.youtube.com/watch?v=T0LfHEwEXXw&feature=youtu.be&t=1m13s'
    }
    
    # 查表
    keyword_mapping[received_text]
	end

end