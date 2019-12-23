require 'line/bot'
require 'rest-client'
require 'nokogiri'
require 'open-uri'

class No9527Controller < ApplicationController
	protect_from_forgery with: :null_session

	def getDataByUrl(url)
		doc = ''
		if(['Beauty', 'sex', 'Gossiping', 'japanavgirls'].any? { |i| url.include? i })
			raw_cookie = { over18: '1' }
			cookie = raw_cookie.to_a.map {|key,val| "%s=%s" % [key, val]}.join '; '
			doc = Nokogiri::HTML(open(url, "Cookie" => cookie))
		else
			doc = Nokogiri::HTML(open(url))
		end

		domain = 'https://www.ptt.cc'
		yesterday = Date.yesterday.strftime('%Y')
		list = []
		
		xmlDoc = doc.css('div.r-ent')	
		size = xmlDoc.length
		xmlDoc.each do |element|
			unless (element.css('span').text.include?'X') || (element.css('div.meta div.author').text == '-')
				# 避免月份為個位數的bug
				date = element.css('div [class=date]').text
				date.sub!(' ', '0')
				list << {
					popularity: element.css('span').text,
					date: yesterday + '/' + date,
					author: element.css('div.meta div.author').text,
					title: element.css('div.title a').text,
					url: domain + element.css('div.title a').attribute('href').to_s
				}
			end
		end
		return list
	end

	def currentTime()
		rlt = Time.now + 8 * 60 * 60
		rltFormat = rlt.strftime('%Y/%m/%d %H:%M:%S')
		# render plain: rltFormat
		return "現在時間： " + rltFormat
	end

	def eat(kanban)
	# def eat()
		# kanban = 'Gossiping'
		# kanbanList = ['Gossiping', 'C_Chat', 'Stock', 'Baseball', 'Lifeismoney',
		# 							'sex', 'LoL', 'movie', 'marriage', 'car', 'Beauty', 'WomenTalk',
		# 							'Boy-Girl', 'Japan_Travel', 'marvel', 'japanavgirls', 'Kaohsiung']
		# return nil unless kanbanList.any? { |i| kanban.include? i }
		today = Time.now + 8 * 60 * 60
		yesterday = today - 1.day
		todayFormat = today.strftime('%Y/%m/%d')
		yesterdayFormat = yesterday.strftime('%Y/%m/%d')
		
		url = 'https://www.ptt.cc/bbs/' + kanban + '/index.html'
		if(['Beauty', 'sex', 'Gossiping', 'japanavgirls'].any? { |i| kanban.include? i })
			# 處理滿18歲的驗證
			raw_cookie = { over18: '1' }
			cookie = raw_cookie.to_a.map {|key,val| "%s=%s" % [key, val]}.join '; '
			doc = Nokogiri::HTML(open(url, "Cookie" => cookie))
		else
			doc = Nokogiri::HTML(open(url))
		end

		domain = 'https://www.ptt.cc'
		secondPageUrl = doc.at_css('#action-bar-container > div > div.btn-group.btn-group-paging > a:nth-child(2)')['href']
		lastPage = secondPageUrl[secondPageUrl.index('index') + 5 .. -6].to_i + 1
		
		allData = []
		# 取得預設頁數內的所有文章
		(lastPage - 30 .. lastPage).each do |i|
			tempUrl = ''
			tempUrl = 'https://www.ptt.cc/bbs/' + kanban + '/index' + i.to_s + '.html'
			allData = allData + getDataByUrl(tempUrl)
		end

		# 篩選出昨天的所有文章
		# dateFilter = kanban == 'Gossiping' ? allData.select { |item| item[:date] == todayFormat} : allData.select { |item| item[:date] == yesterdayFormat}
		dateFilter = []
		if (['Gossiping', 'NBA', 'Stock', 'SportLottery'].any? { |i| kanban.include? i })
			dateFilter = allData.select { |item| item[:date] == todayFormat }
		else
			dateFilter = allData.select { |item| item[:date] == yesterdayFormat}
		end
		redPopFilter = dateFilter.select { |item| item[:popularity] == '爆' }
		
		popFilterSize = 4 - redPopFilter.size
		popFilter = dateFilter.select { |item| item[:popularity] != '爆' && item[:popularity] != '' }
													.sort_by { |item| -item[:popularity].to_i }
													# .reject { |item| item[:popularity].include?'X' }

		outputList = redPopFilter.size >= 5 ? redPopFilter[0 .. 4] : redPopFilter + popFilter[0 .. popFilterSize]
		
		# 組成送出的字串
		rlt = kanban + "\n\n"
		outputList.each do |i|
			rlt << i[:popularity] + ' [' + i[:date] + '] ' + i[:title] + "\n" + i[:url] + "\n\n"
		end

		# render plain: rlt
		return rlt
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

	# Line Bot API 物件初始化
	def line
		return @line unless @line.nil?
		@line = Line::Bot::Client.new { |config|
			config.channel_secret = 'c9f30185a7af92e0dce842c150ad6691'
			config.channel_token = 'cCfGNO6m2Z23Qah7sj3Aybq2eT9C1v8dH9YNrgPnVXd83y86IZorofx9Rs45eIe8qRS3AjMJFw3oQyq6iDxK1bxLiDuOp3Klk7A2O9cSslrsvxTlKM0bu55gshHB/6EVHUHtyuwqyv8Nel0Th5QOTAdB04t89/1O/w1cDnyilFU='
		}
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

	# PTT關鍵字回覆
	def ptt_mapping(received_text)
		keyword_mapping = {
			'AllTogether' => 'AllTogether', '歐兔' => 'AllTogether', 'O2' => 'AllTogether', '氧氣' => 'AllTogether',
      'BabyMother' => 'BabyMother', '媽寶' => 'BabyMother',
      'Baseball' => 'Baseball', '棒球' => 'Baseball',
      'Beauty' => 'Beauty', '表特' => 'Beauty', '妹子' => 'Beauty',
			'Boy-Girl' => 'Boy-Girl', 'bg' => 'Boy-Girl', 'BG' => 'Boy-Girl', '男女' => 'Boy-Girl',
			'C_Chat' => 'C_Chat', '西洽' => 'C_Chat',
      'car' => 'car', '車板' => 'car',
			'creditcard' => 'creditcard', '卡版' => 'creditcard', '信用卡' => 'creditcard',
      'CVS' => 'CVS', 'cvs' => 'CVS', '超商' => 'CVS',
      'e-shopping' => 'e-shopping', '網購' => 'e-shopping',
			'Finance' => 'Finance', '金融' => 'Finance', '財經' => 'Finance',
			'Food' => 'Food', 'food' => 'Food', '美食' => 'Food',
      'Gossiping' => 'Gossiping', '八卦' => 'Gossiping',
      'HatePolitics' => 'HatePolitics', '政黑' => 'HatePolitics',
			'home-sale' => 'home-sale', 'home' => 'home-sale', '房屋' => 'home-sale',
			'HomeTeach' => 'HomeTeach', 'hometeach' => 'HomeTeach', '家教' => 'HomeTeach',
			'Japan_Travel' => 'Japan_Travel', '日旅' => 'Japan_Travel',
			'japanavgirls' => 'japanavgirls', 'AV' => 'japanavgirls',
			'Japandrama' => 'Japandrama', 'japandrama' => 'Japandrama', '日劇' => 'Japandrama',
			'joke' => 'joke', '就可' => 'joke',
			'Kaohsiung' => 'Kaohsiung', '高雄' => 'Kaohsiung',
      'Lifeismoney' => 'Lifeismoney', '省錢' => 'Lifeismoney',
      'LoL' => 'LoL', 'LOL' => 'LoL',
			'marriage' => 'marriage', '婚姻' => 'marriage',
			'marvel' => 'marvel', '媽佛' => 'marvel',
			'MH' => 'MH', '魔物' => 'MH', '狩獵' => 'MH',
      'MobileComm' => 'MobileComm', '手機' => 'MobileComm',
      'movie' => 'movie', '電影' => 'movie',
      'NBA' => 'NBA', 'nba' => 'NBA',
      'PC_Shopping' => 'PC_Shopping', '電蝦' => 'PC_Shopping',
      'sex' => 'sex', 'Sex' => 'sex', '西斯' => 'sex',
      'Stock' => 'Stock', '股板' => 'Stock', '股票' => 'Stock',
			'Salary' => 'Salary', '職場' => 'Salary', '薪水' => 'Salary',
			'SportLottery' => 'SportLottery', '運彩' => 'SportLottery',
			'Steam' => 'Steam',
			'StupidClown' => 'StupidClown', 'stupid' => 'StupidClown', '笨板' => 'StupidClown',
      'Tainan' => 'Tainan', '台南' => 'Tainan',
      'Tech_Job' => 'Tech_Job', '科技' => 'Tech_Job',
			'WomenTalk' => 'WomenTalk', '女孩' => 'WomenTalk',
		}
		# 查表
		keyword_mapping[received_text]
	end

	# 傳送訊息到 line
  def reply_to_line(reply_text)
		return nil if reply_text.nil?
		
		# 取得 reply token
    reply_token = params['events'][0]['replyToken']
		
		# 設定回覆訊息
		message = {
			type: 'text',
			text: reply_text
		}

    # 傳送訊息
    response = line.reply_message(reply_token, message)
  end

	# 查天氣
	def get_weather(received_text)
    return nil unless received_text.include? '天氣'
		
		# 用RestClient取HTML的body
		url = 'https://www.ptt.cc/bbs/Baseball/index.html'
		doc_KHH = Nokogiri::HTML(open(url))
		puts doc_KHH
		render plain: doc_KHH
	end

	def webhook
		# ====================查天氣====================
		 reply_image = get_weather(received_text)

		 # 有查到的話 後面的事情就不作了
		 unless reply_image.nil?
			 # 傳送訊息到 line
			#  response = reply_image_to_line(reply_image)
 
			 # 回應 200
			 head :ok
 
			 return 
		 end
		
		# ====================查PTT====================
		ptt_kanban = ptt_mapping(received_text)
		if(ptt_kanban != nil)
			reply_text = eat(ptt_kanban)
			# unless reply_text.nil?
			response = reply_to_line(reply_text)
			head :ok
			return 
			# end
		end

		timeList = ['時間', '幾點', 'time']
		if(timeList.any? { |i| received_text.include? i })
			reply_text = currentTime()
			# unless reply_text.nil?
			response = reply_to_line(reply_text)
			head :ok
			return 
			# end
		end

		# 設定回覆文字
		reply_text = keyword_reply(received_text)

		# 傳送訊息
		response = reply_to_line(reply_text)
			
		# 回應 200
		head :ok
	end 


end