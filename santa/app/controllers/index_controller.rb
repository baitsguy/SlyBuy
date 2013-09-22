require 'nokogiri'
require 'open-uri'
require 'timeout'
require 'net/https'
require 'uri'
class IndexController < ApplicationController
		BLOCKED = [
				"at", "about", "across", "of", "on", "the", "how", "when", "TIL", "NSFW", "to"
		]
		NSFW = [
				"sex", "porn", "xxx", "dildo", "lubricant", "vibrator", ""
		]

		def nsfw(str)
				str.split(' ').each do |s|
						if NSFW.any?{ |dirty| dirty.casemp(s)==0 }
								return false
						end
				end
						return true
		end

		def order
				@price = Integer(params[:price])
				low_price = @price-10+@price*0.1
				session["price"] = @price
				begin
						Timeout::timeout(30) {
						begin
								page = 'http://www.reddit.com/'
						
								doc = Nokogiri::HTML(open(page))
								word_list = []
								doc.css('a.title').each do |v|
										word_list.push(v.content)
								end
								begin
								sentence = word_list.sample
										noun = sentence.split(' ').sample
								end while BLOCKED.include?(noun) || noun.length < 5
				
								page = 'http://www.amazon.com/gp/search/?keywords=' + noun +'&low-price='+low_price.to_s+'&high-price='+@price.to_s
								
								doc = Nokogiri::HTML(open(page))
								@query = noun + ' ' + page
								@name = doc.css('.result').first.css('.productTitle').first.content
								@item = doc.css('.result').first.css('.productTitle').first.css('a').first["href"].split('/',6).last
								@cost = doc.css('.result').first.css('.newPrice').first.css('span').first.content
								@image = doc.css('.result').first.css('img').first["src"]
								@failed = Float(@cost.split('$',2).last) > @price || Float(@cost.split('$',2).last) < @price - 10 || @name      =~ /.*[eE][bB][oO]*[kK].*/ || @name =~ /.*[iI][nN][sS][tT][aA][nN][tT].*[vV][iI][dD][eE][oO].*/ || (!params[:nsfw].nil? && nsfw(@name))
						rescue
								retry
						end	while @failed
						}
				rescue Exception => e
						@query += e.inspect + @failed.to_s
				end
						session["asin"] = nil
						session["asin"] = @item
		end
		
		def confirmation
				Zinc.api_key = "dev-fb112aad06264b67a535823768971a22" # set the API key first
				if(params[:access_token]) #redirected from venmo
						zinc_input = JSON.parse(session["zinc_input"])
						#raise session.inspect + session["asin"] + session["zinc_input"].inspect + session["name"].inspect #+ zinc_input
						#raise session[:zinc_input].inspect
						
						uri = URI.parse('https://api.venmo.com/payments')
						http = Net::HTTP.new(uri.host, uri.port)
						request = Net::HTTP::Post.new(uri.request_uri)
						request.set_form_data({"access_token" => params[:access_token], "note" => 'SlyBuy.com purchase.', "amount" => session["price"], "email" => session["email"]})
						response = http.request(request)

						if(response["status"] == "PAYMENT_SETTLED")
								new_order = Zinc::Order.create(zinc_input)
								raise new_order.inspect
								@order_id = new_order[:id]
								@date = new_order[:delivery_date_estimate]
								@status = new_order.status["message"]
								@ASIN = new_order.products.first["pid"]
								o = Order.new(:order_id => new_order[:id], :asin => new_order.products.first["pid"], :date => new_order[:created_date])
								if User.find_by email: session[:email]
										o.User = User.find_by email: zinc_input[:email]
								else
								u = User.new(:email => zinc_input[:email])
								u.save
								o.User = u
								end
								o.save
						else
								@error = "Failed to process payment. Order was not made. Status: #{response['status']}"
						end
				else
						zinc_input = {
								:mode => 'dev', 
								:address => {
										:name => params["name"],
										:address_line1 => params["address1"],
										:zip_code => params["zip"],
										:city => params["city"],
										:state => params["state"],
										:country => "US"
								},
								:products => [
								{
				        :pid => session["asin"],
				        :pid_type => "ASIN",
				    }
								],
								:merchant => 'amazon', 
								:shipping_method => 'standard'
						}
						session["zinc_input"] = zinc_input.to_json.to_s
						session["name"] = params["name"]
						redirect_to "https://api.venmo.com/oauth/authorize?client_id=1396&scope=ACCESS_FRIENDS,ACCESS_PROFILE,MAKE_PAYMENTS"
				end

		end
end
