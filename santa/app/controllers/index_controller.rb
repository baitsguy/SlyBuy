require 'nokogiri'
require 'open-uri'
class IndexController < ApplicationController
		BLOCKED = [
				"at", "about", "across", "of", "on", "the", "how", "when", "TIL", "NSFW", "to"
		]
		def order
				@price = Integer(params[:price])
				low_price = @price-10+@price*0.1
				
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
						@value = doc.css('.result').first.css('.productTitle').first.css('a').first["href"]
						@cost = doc.css('.result').first.css('.newPrice').first.css('span').first.content
						@image = doc.css('.result').first.css('img').first["src"]
						@failed = Float(@cost.split('$',2).last) > @price || Float(@cost.split('$',2).last) < @price - 10 || @name      =~ /.*[eE][bB][oO]*[kK].*/ || @name =~ /.*[iI][nN][sS][tT][aA][nN][tT].*[vV][iI][dD][eE][oO].*/
				rescue Exception=>e
						retry
				end	while @failed

		end
		
		def confirmation
				Zinc.api_key = "dev-fb112aad06264b67a535823768971a22" # set the API key first

				new_order = Zinc::Order.create({:mode => 'dev', :address => {
				    	:name => params[:name],
				    	:address_line1 => params[:address],
				    	:zip_code => params[:zip],
				    	:city => params[:city],
				    	:state => params[:state],
				    	:country => params[:country]
					},
					:products => [
				    {
				        :pid => params[:pid],
				        :pid_type => "ASIN",
				    }
				], :merchant => 'amazon', :shipping_method => 'standard'})

				  # all parameters returned by the {Zinc API}[https://zinc.io/docs] can be used as accessors
				  # puts new_order.ship_date_estimate # => 1336120454


				@order_id = new_order[:id]
				@date = new_order[:delivery_date_estimate]
				@status = new_order.status["message"]
				@ASIN = new_order.products.first["pid"]
		end
end
