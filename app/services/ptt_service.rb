require 'line/bot'
require 'rest-client'
require 'nokogiri'
require 'open-uri'

class PttService
  def initialize(message = "")
    @message = message
  end

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

  def ptt
    kanban = @message
    # kanbanList = ['Gossiping', 'C_Chat', 'Stock', 'Baseball', 'Lifeismoney',
    #               'sex', 'LoL', 'movie', 'marriage', 'car', 'Beauty', 'WomenTalk',
    #               'Boy-Girl', 'Japan_Travel', 'marvel', 'japanavgirls', 'Kaohsiung']
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
    
    popFilterSize = 2 - redPopFilter.size
    popFilter = dateFilter.select { |item| item[:popularity] != '爆' && item[:popularity] != '' }
                          .sort_by { |item| -item[:popularity].to_i }
                          # .reject { |item| item[:popularity].include?'X' }

    outputList = redPopFilter.size >= 3 ? redPopFilter[0 .. 2] : redPopFilter + popFilter[0 .. popFilterSize]
    
    # 組成送出的字串
    rlt = kanban + "\n\n"
    outputList.each do |i|
      rlt << i[:popularity] + ' ' + i[:title] + "\n" + i[:url] + "\n\n"
      # rlt << i[:popularity] + ' [' + i[:date] + '] ' + i[:title] + "\n" + i[:url] + "\n\n"
    end

    return rlt
  end
end