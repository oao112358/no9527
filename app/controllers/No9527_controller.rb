require 'line/bot'
require 'rest-client'
require 'nokogiri'
require 'open-uri'

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
		# Line Bot API 物件初始化
		client = Line::Bot::Client.new { |config|
			config.channel_secret = 'c9f30185a7af92e0dce842c150ad6691'
			config.channel_token = 'cCfGNO6m2Z23Qah7sj3Aybq2eT9C1v8dH9YNrgPnVXd83y86IZorofx9Rs45eIe8qRS3AjMJFw3oQyq6iDxK1bxLiDuOp3Klk7A2O9cSslrsvxTlKM0bu55gshHB/6EVHUHtyuwqyv8Nel0Th5QOTAdB04t89/1O/w1cDnyilFU='
		}
		
		# 取得 reply token
		reply_token = params['events'][0]['replyToken']
	
		# 設定回覆訊息
		message = {
			type: 'text',
			text: '說人話，好嗎？'
		}
	
		# 傳送訊息
		response = client.reply_message(reply_token, message)
			
		# 回應 200
		head :ok
	end 





	# def webhook
	# 	# 查天氣
  #   # reply_image = get_weather(received_text)

  #   # 有查到的話 後面的事情就不作了
  #   # unless reply_image.nil?
  #   #   # 傳送訊息到 line
  #   #   response = reply_image_to_line(reply_image)

  #   #   # 回應 200
  #   #   head :ok

  #   #   return 
  #   # end
		
	# 	# 紀錄頻道
	# 	# Channel.find_or_create_by(channel_id: channel_id)

	# 	# 關鍵字回覆
  #   # reply_text = keyword_reply(received_text)
	
	# 	# 傳送訊息
	# 	# response = reply_to_line(reply_text)
			
	# 	# 回應 200
	# 	head :ok
	# end

	# # Line Bot API 物件初始化
	# def line
	# 	return @line unless @line.nil?
	# 	@line = Line::Bot::Client.new { |config|
	# 		config.channel_secret = 'c9f30185a7af92e0dce842c150ad6691'
	# 		config.channel_token = 'cCfGNO6m2Z23Qah7sj3Aybq2eT9C1v8dH9YNrgPnVXd83y86IZorofx9Rs45eIe8qRS3AjMJFw3oQyq6iDxK1bxLiDuOp3Klk7A2O9cSslrsvxTlKM0bu55gshHB/6EVHUHtyuwqyv8Nel0Th5QOTAdB04t89/1O/w1cDnyilFU='
	# 	}
	# end

	# # 傳送訊息到 line
	# def reply_to_line(reply_text)
	# 	return nil if reply_text.nil?
		
	# 	# 取得 reply token
	# 	reply_token = params['events'][0]['replyToken']
		
	# 	# 設定回覆訊息
	# 	message = {
	# 		type: 'text',
	# 		text: reply_text
	# 	}

	# 	# 傳送訊息
	# 	line.reply_message(reply_token, message)
  # end

	# # 取得對方說的話
	# def received_text
	# 	message = params['events'][0]['message']
  #   message['text'] unless message.nil?
	# end

	# # 關鍵字回覆
	# def keyword_reply(received_text)
	# 	mapping = KeywordMapping.where(keyword: received_text).last
  #   if mapping.nil?
  #     nil
  #   else
  #     mapping.message
  #   end
	# end

	# # 查天氣
	# # def get_weather(received_text)
	# def get_weather
  #   # return nil unless received_text.include? '天氣'
		
	# 	# 用RestClient取HTML的body
	# 	url = 'https://www.ptt.cc/bbs/Baseball/index.html'
	# 	doc_KHH = Nokogiri::HTML(open(url))
	# 	puts doc_KHH
	# 	render plain: doc_KHH
	# end
end