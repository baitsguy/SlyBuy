class Donation < ActiveRecord::Base
  belongs_to :User
  belongs_to :Charity
end
