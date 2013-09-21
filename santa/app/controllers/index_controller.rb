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
				@order_id = params[:id]
				@date = "12:30pm September 20, 2013"
				@status = "Delivering"
		end
end
