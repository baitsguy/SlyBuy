require 'open-uri'
class CharityController < ApplicationController
	def new_Donation
		@donation = Integer(params[:donation])
		low_price = @price-10+@price*0.1
				
		begin
				Timeout::timeout(30) {

				}
		end
	end

	def new_charity
		@donation = Integer(params[:donation])
		low_price = @price-10+@price*0.1
				
		begin
				Timeout::timeout(30) {

				}
		end
	end

		def confirmation
				Zinc.api_key = "dev-fb112aad06264b67a535823768971a22" # set the API key first
				if(params[:access_token]) #redirected from venmo
						#raise session.inspect + session["asin"] + session["zinc_input"].inspect + session["name"].inspect #+ zinc_input
						#raise session[:zinc_input].inspect
						charity = Charity.find(session["charity_input")
						charity.donations += session["amount_input"]
						charity.save
						if User.find_by email: session["email_input"]
							user = User.find_by email: session["email_input"]
						else
							user = User.new(:email => session["email_input"])
							user.save
						end
						donation = Donation.new(:money => session["amount_input"])
						donation.User = user
						donation.Charity = charity
						donation.save

						content = open("http://www.justinscarpetti.com/projects/amazon-wish-lister/api/?id=" + charity.wishlist).read
						wish_list = JSON.parse[content]

						while wish_list.empty?
							for i in wish_list
								if i["new-price"] > charity.donations
									wish_list.remove(i)
								end
							end


							prod = wish_list.sample
							asinsplit = prod["link"].split("dp/", 2).last
							asincode = asinsplit.split("/", 2).first
							zinc_input = {
									:mode => 'dev', 
									:address => {
											:name => charity.name,
											:address_line1 =>charity.address,
											:zip_code => charity.zip,
											:city => charity.city,
											:state => charity.state,
											:country => "US"
									},
									:products => [
									{
					       		 :pid => asincode,
					       		 :pid_type => "ASIN",
					  		  	}
									],
									:merchant => 'amazon', 
									:shipping_method => 'standard'
								}

							new_order = Zinc::Order.create(zinc_input)
							order = Order.new(:order_id => new_order[:id], :asin => new_order.products.first["pid"], :date => new_order[:created_date])
							order.User = user
							order.save

							charity.donations -= new_order.products.first["price"]
						end
				else
						session["charity_input"] = params["charity"]
						session["email_input"] = params["email"]
						session["amount_input"] = params["amount"]
						redirect_to "https://api.venmo.com/oauth/authorize?client_id=1396&scope=ACCESS_FRIENDS,ACCESS_PROFILE,MAKE_PAYMENTS"
				end

		end
end
