class No9527Controller < ApplicationController

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
		print "9527躲在這兒A____A"
		p "9527躲在這兒A____A"
		render plain: response.body
	end

end